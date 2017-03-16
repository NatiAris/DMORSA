#!/bin/bash

mongoimport --port 40000 --db asl --collection sessions --type json --file ./test/sessions.json
mongoimport --port 40000 --db asl --collection legs --type json --file ./test/legs.json
