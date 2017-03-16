sh.addShard("sh1/localhost:30101,localhost:30102")
sh.addShard("sh2/localhost:30201,localhost:30202")
sh.addShard("sh3/localhost:30301,localhost:30302")
sh.addShard("sh4/localhost:30401,localhost:30402")
sh.addShard("sh5/localhost:30501,localhost:30502")
//db.getSiblingDB("config").shards.find()

sh.enableSharding("asl");
//db.getSiblingDB("config").databases.find()
sh.shardCollection("asl.sessions", {_id: 1}); null;
sh.shardCollection("asl.legs", {shkey: 1}); null;
//db.getSiblingDB("config").collections.findOne(); null;

use asl
//db.sessions.ensureIndex({created: 1}); null;
db.legs.ensureIndex({created: 1}); null;
db.legs.ensureIndex({_ses_id: 1}); null;
//use config;
//db.settings.save( { _id:"chunksize", value: 1 } )

//sh.disableBalancing("asl.sessions");
sh.disableBalancing("asl.legs")
sh.addShardTag("sh1", "tag1")
sh.addShardTag("sh2", "tag2")
sh.addShardTag("sh3", "tag3")
sh.addShardTag("sh4", "tag4")
sh.addShardTag("sh5", "tag5")
//sh.status()

//sh.addTagRange("asl.sessions",{"shkey":MinKey},{"shkey":2},"tag1")
//sh.addTagRange("asl.sessions",{"shkey":2},{"shkey":3},"tag2")
//sh.addTagRange("asl.sessions",{"shkey":3},{"shkey":4},"tag3")
//sh.addTagRange("asl.sessions",{"shkey":4},{"shkey":5},"tag4")
//sh.addTagRange("asl.sessions",{"shkey":5},{"shkey":MaxKey},"tag5")
//sh.enableBalancing("asl.sessions")

sh.addTagRange("asl.legs",{"shkey":MinKey},{"shkey":2},"tag1")
sh.addTagRange("asl.legs",{"shkey":2},{"shkey":3},"tag2")
sh.addTagRange("asl.legs",{"shkey":3},{"shkey":4},"tag3")
sh.addTagRange("asl.legs",{"shkey":4},{"shkey":5},"tag4")
sh.addTagRange("asl.legs",{"shkey":5},{"shkey":MaxKey},"tag5")
sh.enableBalancing("asl.legs")
//sh.status()
