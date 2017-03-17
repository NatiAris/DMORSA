# Written by Mikova Valentina
#It returns the call data (session type, from, to, date of creation and completion) in a period of time from
#t to T (Unix time in seconds)

curl "http://localhost:3467/?request_type=time_only&t=1489049832&T=1499136232"  > response_t8.txt