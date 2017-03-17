# Written by Mikova Valentina
#It returns the call data (session type, from, to, date of creation and completion) 
#using the phone number/numbers in the last 24 hours

curl "http://localhost:3467/?request_type=phones_time&phone_ids=10,11&over_last=24"  > response_t1.txt