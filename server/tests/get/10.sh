# Written by Mikova Valentina
#It returns the extended call data (all information of legs and sessions stored in the DB:
#session type, session and leg ids, from, to, date of creation, completion, update) in a period of time from
#t to T (Unix time in seconds)

curl "http://localhost:3467/?request_type=time_only&t=148904983&T=1499136232&verbose=1"  > response_t10.txt