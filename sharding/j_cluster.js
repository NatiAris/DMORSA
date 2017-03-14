sh.addShard("sh1/localhost:30101,localhost:30102")
sh.addShard("sh2/localhost:30201,localhost:30202")
sh.enableSharding("asl")
sh.shardCollection("asl.sessions", {shkey: 1})
use asl
db.sessions.ensureIndex({created: 1})
