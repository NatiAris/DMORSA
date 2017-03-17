# Written by Mikova Valentina
#It returns the extended call data (all information of legs and sessions stored in the DB:
#session type, session and leg ids, from, to, date of creation, completion, update) 
#using the phone number/numbers in the last 24 hours

curl "http://localhost:3467/?request_type=phones_time&phone_ids=10&over_last=24&verbose=1" > response_t2.txt