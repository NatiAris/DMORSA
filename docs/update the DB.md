включение сервера монги на фоне (из cmd):
```
start /min mongod
```
включение монги (из cmd):
```
mongo
```
использовать бд, где asl - наша бд (из mongo):
```
use asl
```
удаление базы данных [нужно, т.к. будет ошибка пересечения] (из mongo):
```
db.dropDatabase()
```
выйти из монги (из mongo):
```
exit
```
[запускать из директории куда вы положили эти файлики]
загрузить коллекции в бд из файлов (из cmd):
```
mongoimport --db asl --collection accounts --file accounts.json
mongoimport --db asl --collection sessions --file sessions.json
```
