# Written by Mikova Valentina

for (( i=100; i<999; i++ ))
do
	_aid1=$(shuf -i 100000000000-999999999999 -n 1)
	_aid2=$(shuf -i 100000000000-999999999999 -n 1)
	printf "{\"_aid\":{\"\$oid\": \"$_aid1$_aid2\"},\"phones\":[" >> accounts.json
	for (( j=1; j<10; j++ ))
	do
		printf "$i," >> accounts.json
		let "i=i+1"
	done
	printf "$i]}

	" >> accounts.json
done 