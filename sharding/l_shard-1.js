config = {
   _id: "shard-1",
   members: [
      {_id: 0, host: "localhost:30101"},
      {_id: 1, host: "localhost:30102"},
      {_id: 2, host: "localhost:30103", arbiterOnly: true},
   ]
}
rs.initiate(config)
