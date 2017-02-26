# coding: utf-8

import time
# Interaction with mongo and json files
import pymongo
import datetime
import json
from bson import json_util
# For the server
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import urlparse, parse_qsl

mongo_client = pymongo.MongoClient('localhost', 27017)
db = mongo_client.asl
accounts = db.accounts
sessions = db.sessions

# Example post
'''
post = {"author": "Name",
        "text"  : "Some stupid text",
        "tags"  : ["mongodb", "python", "pymongo"],
        "date"  : datetime.datetime.utcnow()}
'''

# Non-verbose case fields
nv_fields = {'type', 'from', 'to', 'created', 'updated', 'completed'}


def get_phones_time(phone_ids=None, account_id=None, verbose=False,
                   t=None, T=None, over_last=None):
    if not (over_last or (t and T)):
        raise NameError('Time not specified')
    if over_last:
        T = datetime.datetime.now()  # Memento time zone
        t = T - datetime.timedelta(hours=int(over_last))
    if not any((phone_ids, account_id)):
        raise NameError('Missing phone/account ids')
    if account_id:
        phone_ids = accounts.find_one({'_id': int(account_id)})
    else:
        phone_ids = list(map(int, phone_ids.split(',')))
    # not (last change < t or beginning > T) => take
    # last change ≥ t and beginnig ≤ T
    # print(t, T, over_last, phoneID, sep='\n')
    findings = sessions.find({'party'  : {'$in': phone_ids},
                              'updated': {'$gte': t},
                              'created': {'$lte': T}})
    if not verbose:
        findings = [{k: finding[k] for k in nv_fields & finding.keys()} for finding in findings]
    else:
        findings = list(findings)
    print('Relative success', '\n'.join(str(x) for x in findings))
    return json.dumps(findings, default=json_util.default)


def get_phone_n(n, phone_id, verbose=False):  # Will probably change if we implement queues
    findings = sessions.find({'party': int(phone_id)}).sort([('updated', 1)]).limit(int(n))
    if not verbose:
        findings = [{k: finding[k] for k in nv_fields & finding.keys()} for finding in findings]
    else:
        findings = list(findings)
    print('Relative success', '\n'.join(str(x) for x in findings))
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
    print('Relative success', '\n'.join(str(x) for x in findings))
    return json.dumps(findings, default=json_util.default)


def get_request(request_type=None, **kwargs):
    ''' 
    verbose=False,
    accound_id=None, phone_ids=None,
    t=None, T=None, over_last=None, N=None
    '''
    switch = {'phone_n': get_phone_n,
              'time_only': get_time_only,
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


# Server itself

class MyRequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        try:
            path = self.path
            query = urlparse(path).query
            qs = dict(parse_qsl(query))
            self.send_response(200)
            self.send_header('content-type', 'application/json')
            self.end_headers()
            self.flush_headers()
            # self.wfile.write(bytes("hello!\n" + str(qs) + '\n', 'utf-8'))
            response = get_request(**qs)
            self.wfile.write(bytes(str(response) + '\n', 'utf-8'))
        except Exception as ex:
            print(ex)
    
    def do_POST(self):
        pass


serv = HTTPServer(("localhost", 3467), MyRequestHandler)

print('Entering mainloop')
serv.serve_forever()
