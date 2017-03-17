# Written by Mikova Valentina
#It returns extended information (all information of legs and sessions stored in the DB:
#session type, session and leg ids, from, to, date of creation, completion, update) 
#about call for the last 24 hours

curl "http://localhost:3467/?request_type=time_only&over_last=24&verbose=1"  > response_t8.txt