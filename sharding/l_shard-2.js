config = {
   _id: "shard-2",
   members: [
      {_id: 0, host: "localhost:30201"},
      {_id: 1, host: "localhost:30202"},
      {_id: 2, host: "localhost:30203", arbiterOnly: true},
   ]
}
rs.initiate(config)
