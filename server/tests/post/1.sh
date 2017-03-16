#!/usr/bin/env bash
# Creates a session with constant session_id and leg_id, using all 4 POST methods, pretty prints the results and clears sessions collection.

# Create a session
curl -X POST --data @1/cs.json http://localhost:3467/ --header "Content-Type:application/json"
# Create a leg
curl -X POST --data @1/cl.json http://localhost:3467/ --header "Content-Type:application/json"
# Update the session
curl -X POST --data @1/ul.json http://localhost:3467/ --header "Content-Type:application/json"
# Update the leg
curl -X POST --data @1/us.json http://localhost:3467/ --header "Content-Type:application/json"
# Get the data (commented since field names changed)
# curl "http://localhost:3467/?request_type=time_only&over_last=100000"
# mongo < get_sessions.js
# Clear sessions collection
# mongo < purge.js

# Get sessions AND purge
mongo < ../aux/get_and_purge.js
