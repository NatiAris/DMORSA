# Written by Mikova Valentina
#It returns extended information (all information of legs and sessions stored in the DB:
#session type, session and leg ids, from, to, date of creation, completion, update) about 24 last call  
#using the phone number

curl "http://localhost:3467/?request_type=phone_n&phone_id=10&n=24&verbose=1"  > response_t6.txt