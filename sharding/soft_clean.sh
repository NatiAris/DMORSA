# Written by Salavat Garifullin
# Removes old data, without consequences for the cluste

cleaner="db.legs.remove({});
db.sessions.remove({});
db.accounts.remove({});"
mongo asl --port 40000 --quiet --norc --eval="$cleaner"
