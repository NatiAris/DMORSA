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
log = logging.getLogger()
dprint = lambda *x: logging.debug(' '.join(map(str, x)))
iprint = lambda *x: logging.info(' '.join(map(str, x)))
eprint = lambda *x: logging.exception(' '.join(map(str, x)))
dprint('DEBUG=%s' % DEBUG)


mongo_client = pymongo.MongoClient('localhost', 27017)
db = mongo_client.asl
accounts = db.accounts
sessions = db.sessions
legs = db.legs

# Non-verbose case fields
nv_fields = {'session_type', 'from_', 'to_', 'created', 'updated', 'terminated'}


def get_phone_time(phone_id, verbose=False,
                   t=None, T=None, over_last=None):
    phone_id = int(phone_id)
    if not (over_last or (t and T)):
        raise NameError('Time not specified')
    if over_last:
        T = datetime.datetime.utcnow()
        t = T - datetime.timedelta(hours=int(over_last))
    else:
        T = datetime.datetime.utcfromtimestamp(int(T))
        t = datetime.datetime.utcfromtimestamp(int(t))
    # dprint(t, T, over_last, phone_id, sep='\n')
    # not (ended < t or beginning > T) => take
    # ended ≥ t and beginning ≤ T
    findings = legs.find({'$or': [{'from_': phone_id}, {'to_': phone_id}],
                          'created': {'$lte': T},
                          'terminated': {'$gte': t}},
                         {'created': 1, 'terminated': 1, '_sid': 1})
    out = []
    for leg in findings:
        session = sessions.find_one({'_id': leg['_sid']})
        finding = {'created': leg['created'],
                   'terminated': leg['terminated'],
                   'from_': session['from_'],
                   'to_': session['to_']}
        out.append(finding)
    # TODO: account for verbose
    # findings = sessions.find({})
    # dprint('findings:', findings)
    # if not verbose:
    #     findings = [{k: finding[k] for k in nv_fields & finding.keys()} for finding in findings]
    # else:
    #     findings = list(findings)
    # dprint('Relative success\tphone_time\n', '\n'.join(str(x) for x in findings))
    return out


def get_phones_time(phone_ids=None, account_id=None, verbose=False,
                    t=None, T=None, over_last=None):
    if not any((phone_ids, account_id)):
        raise NameError('Missing phone/account ids')
    if account_id:
        phone_ids = list(map(int, accounts.find_one({'_id': int(account_id)})['phones']))
    else:
        phone_ids = list(map(int, phone_ids.split(',')))

    findings = (get_phone_time(phone_id, verbose=verbose, t=t, T=T, over_last=over_last)
                for phone_id in phone_ids)
    # Nested cycles in python list comprehension is one thing I find confusing myself, but it's fast
    out = [x for sublist in findings for x in sublist]
    dprint('Relative success\tphones_time\n', '\n'.join(str(x) for x in out))
    return out


def get_phone_n(phone_id, n, verbose=False):
    phone_id = int(phone_id)
    n = int(n)
    findings = legs.find({'$or': [{'from_': phone_id}, {'to_': phone_id}]}).sort([('created', -1)]).limit(n)
    out = []
    for leg in findings:
        session = sessions.find_one({'_id': leg['_sid']})
        finding = {'created': leg['created'],
                   'terminated': leg['terminated'],
                   'from_': session['from_'],
                   'to_': session['to_']}
        out.append(finding)
    # TODO: Account for verbose
    # if not verbose:
    #     findings = [{k: finding[k] for k in nv_fields & finding.keys()} for finding in findings]
    # else:
    #     findings = list(findings)
    dprint('Relative success\tphone_n\n', '\n'.join(str(x) for x in out))
    return out


def get_time_only(t=None, T=None, over_last=None, verbose=False):
    if not (over_last or (t and T)):
        raise NameError('Time not specified')
    if over_last:
        T = datetime.datetime.utcnow()
        t = T - datetime.timedelta(hours=int(over_last))
    else:
        T = datetime.datetime.utcfromtimestamp(int(T))
        t = datetime.datetime.utcfromtimestamp(int(t))
    findings = legs.find({'terminated': {'$gte': t},
                          'created': {'$lte': T}})
    out = []
    for leg in findings:
        session = sessions.find_one({'_id': leg['_sid']})
        finding = {'created': leg['created'],
                   'terminated': leg['terminated'],
                   'from_': session['from_'],
                   'to_': session['to_']}
        out.append(finding)
    # TODO: Verbose case handling
    # if not verbose:
    #     findings = [{k: finding[k] for k in nv_fields & finding.keys()} for finding in findings]
    # else:
    #     findings = list(findings)
    dprint('Relative success\ttime_only\n', '\n'.join(str(x) for x in out))
    return out


def get_request(request_type=None, **kwargs):
    switch = {'phone_n'    : get_phone_n,
              'time_only'  : get_time_only,
              'phone_time' : get_phone_time,
              'phones_time': get_phones_time}
    try:
        handler = switch[request_type]
        result = handler(**kwargs)
        return 200, json.dumps(result, default=json_util.default)
    except KeyError as ex:
        return 400, 'Unknown request type\n' + str(ex)
    except NameError as ex:
        return 400, 'Invalid parameter\n' + str(ex)
    except TypeError as ex:
        return 400, 'Invalid keyword\n' + str(ex)


def create_session(session_type, created, from_, to_, session_id=None):
    session_id = objectid.ObjectId(session_id)
    from_, to_ = int(from_), int(to_)
    session_id = sessions.insert_one({'_id'         : session_id,
                                      'session_type': session_type,
                                      'created'     : created,
                                      'updated'     : datetime.datetime.utcnow(),
                                      'from_'       : from_,
                                      'to_'         : to_}).inserted_id
    dprint('Session id:', session_id)
    return session_id


def create_leg(session_id, created, from_, to_, leg_id=None):
    session_id = objectid.ObjectId(session_id)
    leg_id = objectid.ObjectId(leg_id)
    leg_id = legs.insert_one({'_id': leg_id,
                              '_sid': session_id,
                              'created': created,
                              'updated': datetime.datetime.utcnow(),
                              'from_': from_,
                              'to_': to_,
                              'shkey': 1}).inserted_id
    dprint('Leg id:', leg_id)
    return leg_id


def update_session(session_id, terminated):
    session_id = objectid.ObjectId(session_id)
    response = sessions.update_one({'_id': session_id},
                                   {
                                       '$set': {'terminated': terminated},
                                       '$currentDate': {'updated': True}
                                   }).modified_count
    dprint('Modified count:', response)
    return response


def update_leg(leg_id, terminated):
    leg_id = objectid.ObjectId(leg_id)
    response = legs.update_one({'_id': leg_id},
                               {
                                   '$set': {'terminated': terminated},
                                   '$currentDate': {'updated': True}
                               }).modified_count
    dprint('Modified count:', response)
    return response


def post_request(data):
    switch = {'create_session': create_session,
              'create_leg'    : create_leg,
              'update_session': update_session,
              'update_leg'    : update_leg}
    try:
        request_type = data.pop('request_type')
        handler = switch[request_type]
        return 201, handler(**data)
    except KeyError as ex:
        return 400, 'Unknown request type\n' + str(ex)


# Server itself

class MyRequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        try:
            path = self.path
            query = urlparse(path).query
            qs = dict(parse_qsl(query))
            r_code, response = get_request(**qs)
            self.send_response(r_code)
            self.send_header('content-type', 'application/json')
            self.end_headers()
            self.flush_headers()
            self.wfile.write(bytes(str(response) + '\n', 'utf-8'))
        except Exception as ex:
            self.send_response_only(500)
            eprint(ex)
    
    def do_POST(self):
        try:
            length = int(self.headers['content-length'])
            rawdata = self.rfile.read(length)
            data = json_util.loads(str(rawdata, 'utf-8'))
            r_code, response = post_request(data)
            self.send_response(r_code)
            self.send_header('content-type', 'text/html')
            self.end_headers()
            self.flush_headers()
            self.wfile.write(bytes(str(response) + '\n', 'utf-8'))
        except Exception as ex:
            self.send_response_only(500)
            eprint(ex)


if __name__ == '__main__':
    serv = HTTPServer(("localhost", 3467), MyRequestHandler)
    iprint('Entering mainloop', serv.server_address)
    serv.serve_forever()
