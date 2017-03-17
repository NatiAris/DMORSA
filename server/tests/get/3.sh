# Written by Mikova Valentina
#It returns the call data (session type, from, to, date of creation and completion) 
#using the account id(for all numbers in the account) in the last 24 hours

curl "http://localhost:3467/?request_type=phones_time&account_id=1&over_last=24"  > response_t3.txt