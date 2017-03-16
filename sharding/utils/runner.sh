> temp.temp
> date.temp

for (( i=0; i<1; i++ ))
do
	./call.sh
done

cat temp.temp | sort | uniq -c | sort -bgr
cat date.temp | sort | tail -1 | perl -pe 's/(\d+)\d{3}/localtime($1)/e'