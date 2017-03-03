# Naive test for all four get methods

mongoimport --db asl --collection sessions --file testset2/sessions.json --jsonArray
mongoimport --db asl --collection accounts --file testset2/accounts.json --jsonArray


# curl "http://localhost:3467/?request_type=phone_time&over_last=1000&phone_id=1001"

curl "http://localhost:3467/?request_type=phones_time&over_last=1000&phone_ids=1001,1002" | python -m json.tool

curl "http://localhost:3467/?request_type=phones_time&over_last=1000&account_id=20001" | python -m json.tool

curl "http://localhost:3467/?request_type=phone_n&n=10&phone_id=1002" | python -m json.tool

curl "http://localhost:3467/?request_type=time_only&over_last=1000" | python -m json.tool

curl "http://localhost:3467/?request_type=phones_time&over_last=1000&phone_ids=1001&verbose=1" | python -m json.tool

mongo < testset2/purge.js
