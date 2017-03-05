# coding: utf-8

# import time
# import random
import logging
import sys
# Interaction with mongo and json files
import pymongo
import datetime
import json
from bson import json_util, objectid
# For the server
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import urlparse, parse_qsl


try:
    DEBUG = bool(int(sys.argv[1]))
except IndexError:
    DEBUG = True
logging_level = logging.DEBUG if DEBUG else logging.INFO
logging.basicConfig(level=logging_level, stream=sys.stdout)
dprint = lambda *x: logging.debug(' '.join(map(str, x)))
iprint = lambda *x: logging.info(' '.join(map(str, x)))
eprint = lambda *x: logging.error(' '.join(map(str, x)))
dprint('DEBUG=%s' % DEBUG)

mongo_client = pymongo.MongoClient('localhost', 27017)
db = mongo_client.asl
accounts = db.accounts
sessions = db.sessions

# Non-verbose case fields
nv_fields = {'session_type', 'from_', 'to_', 'created', 'updated', 'terminated'}


def get_phone_time(phone_id, verbose=False,
                   t=None, T=None, over_last=None):
    if not (over_last or (t and T)):
        raise NameError('Time not specified')
    if over_last:
        T = datetime.datetime.utcnow()
        t = T - datetime.timedelta(hours=int(over_last))
    else:
        T = datetime.datetime.utcfromtimestamp(T)
        t = datetime.datetime.utcfromtimestamp(t)
    # not (ended < t or beginning > T) => take
    # ended ≥ t and beginnig ≤ T
    # dprint(t, T, over_last, phone_id, sep='\n')
    findings = sessions.find({'participants': phone_id,
                              'created'     : {'$lte': T},
                              'terminated'  : {'$gte': t}})
    # findings = sessions.find({})
    # dprint('findings:', findings)
    if not verbose:  # TODO: Check if mongo's method faster
        findings = [{k: finding[k] for k in nv_fields & finding.keys()} for finding in findings]
    else:
        findings = list(findings)
    # dprint('Relative success\tphone_time\n', '\n'.join(str(x) for x in findings))
    return list(findings)


def get_phones_time(phone_ids=None, account_id=None, verbose=False,
                    t=None, T=None, over_last=None):
    if not any((phone_ids, account_id)):
        raise NameError('Missing phone/account ids')
    if account_id:
        phone_ids = list(map(int, accounts.find_one({'_id': int(account_id)})['phones']))
    else:
        phone_ids = list(map(int, phone_ids.split(',')))

    findings = [get_phone_time(phone_id, verbose=verbose, t=t, T=T, over_last=over_last)
                for phone_id in phone_ids]
    dprint('Relative success\tphones_time\n', '\n'.join(str(x) for x in findings))
    return json.dumps(findings, default=json_util.default)


def get_phone_n(n, phone_id, verbose=False):  # Will probably change if we implement queues
    findings = sessions.find({'participants': int(phone_id)}).sort([('updated', 1)]).limit(int(n))
    if not verbose:
        findings = [{k: finding[k] for k in nv_fields & finding.keys()} for finding in findings]
    else:
        findings = list(findings)
    dprint('Relative success\tphone_n\n', '\n'.join(str(x) for x in findings))
    return json.dumps(findings, default=json_util.default)


def get_time_only(t=None, T=None, over_last=None, verbose=False):
    if not (over_last or (t and T)):
        raise NameError('Time not specified')
    if over_last:
        T = datetime.datetime.now()  # Memento time zone
        t = T - datetime.timedelta(hours=int(over_last))
    else:
        T = datetime.datetime.utcfromtimestamp(T)
        t = datetime.datetime.utcfromtimestamp(t)
    findings = sessions.find({'updated': {'$gte': t},
                              'created': {'$lte': T}})
    if not verbose:
        findings = [{k: finding[k] for k in nv_fields & finding.keys()} for finding in findings]
    else:
        findings = list(findings)
    dprint('Relative success\ttime_only\n', '\n'.join(str(x) for x in findings))
    return json.dumps(findings, default=json_util.default)


def get_request(request_type=None, **kwargs):
    switch = {'phone_n'    : get_phone_n,
              'time_only'  : get_time_only,
              'phone_time' : get_phone_time,
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
    session_id = objectid.ObjectId()
    session_id = sessions.insert_one({'_id'         : session_id,
                                      'session_type': session_type,
                                      'created'     : created,
                                      'from_'       : from_,
                                      'to_'         : to_,
                                      'legs'        : []}).inserted_id
    dprint(session_id)
    return session_id


def create_leg(session_id, created, from_, to_):
    created = datetime.datetime.utcfromtimestamp(created['$date'] // 1e3)
    leg_id = objectid.ObjectId()
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
            eprint(ex)
    
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
            eprint(ex)


if __name__ == '__main__':
    serv = HTTPServer(("localhost", 3467), MyRequestHandler)
    iprint('Entering mainloop', serv.server_address)
    serv.serve_forever()
