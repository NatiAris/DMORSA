- `setup.sh` completely (re)installs the entire cluster with the entire infrastructure
- `test_commands.md` contains various commands for testing
- `restart.sh` allows you to restart cluster without reinstalling
- Now you can connect to the `mongos --port 40000`, and everything should work

Additional description:
- `shutdown.sh` - turns off the cluster
- `hard_clean.sh` - completely removes the entire cluster (should be disabled)
- `run.sh` - runs all mongod servers
- `initiate.sh` - configures the entire relationship
- `db_generation.sh` - generates the DB in `test`
- `import.sh` - imports the DB from the `test`
- `soft_clean.sh` - removes old data, without consequences for the cluster
- The folders `test` and `data` are not visible to the repository

