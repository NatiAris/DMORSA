use asl
db.accounts.find({}).pretty()
db.sessions.find({}).pretty()
db.legs.find({}).pretty()
db.accounts.remove({})
db.sessions.remove({})
db.legs.remove({})
