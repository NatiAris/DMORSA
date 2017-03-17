# Written by Mikova Valentina
#It returns the extended call data (all information of legs and sessions stored in the DB:
#session type, session and leg ids, from, to, date of creation, completion, update) 
#using account id(for all numbers in the account) in the last 24 hours

curl "http://localhost:3467/?request_type=phones_time&account_id=1&over_last=24&verbose=1"  > response_t4.txt