# coding: utf-8

# import time
import random
import sys
# Interaction with mongo and json files
import pymongo
import datetime
import json
from bson import json_util
# For the server
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import urlparse, parse_qsl

print(sys.argv)
try:
    DEBUG = int(sys.argv[1])
except Exception:
    DEBUG = 1


def dprint(*args, **kwargs):
    if DEBUG:
        print(*args, **kwargs)

mongo_client = pymongo.MongoClient('localhost', 27017)
db = mongo_client.asl
accounts = db.accounts
sessions = db.sessions

# Non-verbose case fields
nv_fields = {'session_type', 'from_', 'to_', 'created', 'updated', 'terminated'}


def get_phone_time(phone_id, t, T, verbose):
    findings = sessions.find({'participants': phone_id,
                              'created': {'$lte': T},
                              'terminated': {'$gte': t}})
    return list(findings)


def get_phones_time(phone_ids=None, account_id=None, verbose=False,
                   t=None, T=None, over_last=None):
    dprint(locals())
    if not (over_last or (t and T)):
        raise NameError('Time not specified')
    if over_last:
        T = datetime.datetime.now()  # Memento time zone
        t = T - datetime.timedelta(hours=int(over_last))
    if not any((phone_ids, account_id)):
        raise NameError('Missing phone/account ids')
    if account_id:
        phone_ids = list(accounts.find_one({'_id': int(account_id)}).phones)
    else:
        phone_ids = list(map(int, phone_ids.split(',')))
    # not (last change < t or beginning > T) => take
    # last change ≥ t and beginnig ≤ T
    # dprint(t, T, over_last, phoneID, sep='\n')
    findings = sessions.find({'participants'  : {'$in' : phone_ids},
                              'terminated': {'$gte': t},
                              'created': {'$lte': T}})
    if not verbose:
        findings = [{k: finding[k] for k in nv_fields & finding.keys()} for finding in findings]
    else:
        findings = list(findings)
    dprint('Relative success\n', '\n'.join(str(x) for x in findings))
    return json.dumps(findings, default=json_util.default)


def get_phone_n(n, phone_id, verbose=False):  # Will probably change if we implement queues
    findings = sessions.find({'participants': int(phone_id)}).sort([('updated', 1)]).limit(int(n))
    if not verbose:
        findings = [{k: finding[k] for k in nv_fields & finding.keys()} for finding in findings]
    else:
        findings = list(findings)
    dprint('Relative success\n', '\n'.join(str(x) for x in findings))
    return json.dumps(findings, default=json_util.default)


def get_time_only(t=None, T=None, over_last=None, verbose=False):
    if not (over_last or (t and T)):
        raise NameError('Time not specified')
    if over_last:
        T = datetime.datetime.now()  # Memento time zone
        t = T - datetime.timedelta(hours=int(over_last))
    findings = sessions.find({'updated': {'$gte': t},
                              'created': {'$lte': T}})
    if not verbose:
        findings = [{k: finding[k] for k in nv_fields & finding.keys()} for finding in findings]
    else:
        findings = list(findings)
    dprint('Relative success\n', '\n'.join(str(x) for x in findings))
    return json.dumps(findings, default=json_util.default)


def get_request(request_type=None, **kwargs):
    ''' 
    verbose=False,
    accound_id=None, phone_ids=None,
    t=None, T=None, over_last=None, N=None
    '''
    switch = {'phone_n'    : get_phone_n,
              'time_only'  : get_time_only,
              'phones_time': get_phones_time}
    try:
        handler = switch[request_type]
        return handler(**kwargs)
    except KeyError as ex:
        return 'Unknown request type\n' + str(ex)
    except NameError as ex:
        return 'Invalid parameter\n' + str(ex)
    except TypeError as ex:
        return 'Invalid keyword\n' + str(ex)


def create_session(session_type, created, from_, to_):
    created = datetime.datetime.utcfromtimestamp(created['$date'] // 1e3)
    session_id = 8 if DEBUG else random.getrandbits(96) # TODO: I'm really sorry for doing this even for testing
    session_id = sessions.insert_one({'_id'         : session_id,
                                      'session_type': session_type,
                                      'created'     : created,
                                      'from_'       : from_,
                                      'to_'         : to_,
                                      'legs'        : []}).inserted_id
    # dprint(sessions.find_one({}))
    return session_id


def create_leg(session_id, created, from_, to_):
    created = datetime.datetime.utcfromtimestamp(created['$date'] // 1e3)
    leg_id = 17 if DEBUG else random.getrandbits(96) # TODO: Testing-time hard-code
    modcount = sessions.update_one({'_id': session_id},
                                   {
                                       '$addToSet': {'legs': {'_id'    : leg_id,
                                                              'created': created,
                                                              'from_'  : from_,
                                                              'to_'    : to_}}
                                   }).modified_count
    dprint(modcount)

    return leg_id


def update_session(session_id, terminated):
    terminated = datetime.datetime.utcfromtimestamp(terminated['$date'] // 1e3)
    response = sessions.update_one({'_id': session_id},
                                   {
                                       '$set': {'terminated': terminated},
                                       '$currentDate': {'updated': True}
                                   }).modified_count
    dprint(response)
    return response


def update_leg(session_id, leg_id, terminated):
    terminated = datetime.datetime.utcfromtimestamp(terminated['$date'] // 1e3)
    response = sessions.update_one({'_id': session_id, 'legs._id': leg_id},
                                   {
                                        '$set': {'legs.$.terminated': terminated},
                                        '$currentDate': {'updated': True}
                                   }).modified_count
    dprint(response)
    return response


def post_request(data):
    switch = {'create_session': create_session,
              'create_leg'    : create_leg,
              'update_session': update_session,
              'update_leg'    : update_leg}
    try:
        request_type = data.pop('request_type')
        handler = switch[request_type]
        return handler(**data)
    except KeyError as ex:
        return 'Unknown request type\n' + str(ex)


# Server itself

class MyRequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        try:
            path = self.path
            query = urlparse(path).query
            qs = dict(parse_qsl(query))
            response = get_request(**qs)
            self.send_response(200)
            self.send_header('content-type', 'application/json')
            self.end_headers()
            self.flush_headers()
            self.wfile.write(bytes(str(response) + '\n', 'utf-8'))
        except Exception as ex:
            dprint(ex)
    
    def do_POST(self):
        try:
            length = int(self.headers['content-length'])
            data = json.loads(str(self.rfile.read(length), 'utf-8'))
            response = post_request(data)
            self.send_response(200)
            self.send_header('content-type', 'text/html')
            self.end_headers()
            self.flush_headers()
            self.wfile.write(bytes(str(response) + '\n', 'utf-8'))
        except Exception as ex:
            dprint(ex)


if __name__ == '__main__':
    serv = HTTPServer(("localhost", 3467), MyRequestHandler)
    print('Entering mainloop', serv.server_address)
    serv.serve_forever()
