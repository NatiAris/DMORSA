# Written by Salavat Garifullin

cleaner="db.legs.remove({});
db.sessions.remove({});
db.accounts.remove({});"
mongo asl --port 40000 --quiet --norc --eval="$cleaner"
