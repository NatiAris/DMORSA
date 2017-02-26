К нам может прийти либо список номеров:
```
Phones = [201, 202] 
```
Либо id аккаунта:
```
Phones = db.accounts.findOne({_id: 22}).phones 
```
Так же приходит промежуток времени:
```
TT = [ ISODate("2017-02-21T14:20:00Z"), ISODate("2017-02-21T14:40:00Z") ] 
```
И количество последних N (для второго запроса):
```
N = 10 
```
Выводимая сессия может выглядеть либо так (где bool - условие на вывод легов):
```
Out = {legs:bool, _id:0, type:1, from:1, to:1, party:1, created:1, completed:1}  
```
Тогда для поиска по номерам:
```
{party: {$in: Phones}}
```
по времени
```
{completed: {$gte: TT[0]}, created: {$lte: TT[1]}}
```
по времени и номерам:
```
{party: {$in: Phones}, completed: {$gte: TT[0]}, created: {$lte: TT[1]}}
```
последние N дописываем в конце:
```
.sort({completed:1}).limit(N) 
```
Например:
```
db.sessions.find({completed: {$gte: TT[0]}, created: {$lte: TT[1]}}, Out) 
db.sessions.find({party: {$in: Phones}}, Out).sort({completed:1}).limit(N)
```
