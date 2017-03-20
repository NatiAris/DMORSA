# Written by Salavat Garifullin

DIR=$(dirname "${BASH_SOURCE[0]}")

mongoimport --port 40000 --db asl --collection accounts --type json --file $DIR/test/accounts.json &
mongoimport --port 40000 --db asl --collection sessions --type json --file $DIR/test/sessions.json
mongoimport --port 40000 --db asl --collection legs --type json --file $DIR/test/legs.json
