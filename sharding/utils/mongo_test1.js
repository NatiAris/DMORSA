// Written by Mikova Valentina
// It sends requests to mongo to search the generated GET-requests.

now = ISODate().getTime()
out={_id:0,terminated:1,created:1}
var file = cat("f1.json")
db.legs.find(file, out)
