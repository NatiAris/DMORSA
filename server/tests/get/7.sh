# Written by Mikova Valentina
#It returns information (session type, from, to, date of creation and completion) 
#about call for the last 24 hours

curl "http://localhost:3467/?request_type=time_only&over_last=24"  > response_t7.txt