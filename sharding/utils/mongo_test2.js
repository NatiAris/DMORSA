out={_id:0,terminated:1,created:1}

var file = cat("f2.json")

db.legs.find(file, out).