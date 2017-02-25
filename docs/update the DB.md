включение сервера монги на фоне:
```bash
start /min mongod
```
включение монги:
```bash
mongo
```
использовать бд, где asl - наша бд:
```mongo
use asl
```
удаление базы данных [нужно, т.к. будет ошибка пересечения]:
```
db.dropDatabase()
```
выйти из монги:
```
exit
```
[запускать из директории куда вы положили эти файлики]
загрузить коллекции в бд из файлов:
```
mongoimport --db asl --collection accounts --file accounts.json
mongoimport --db asl --collection sessions --file sessions.json
```
