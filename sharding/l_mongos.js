sh.addShard("shard-1/localhost:30101,localhost:30102")
sh.addShard("shard-2/localhost:30201,localhost:30202")
sh.enableSharding("asl")
sh.shardCollection("asl.sessions", {shkey: 1})

