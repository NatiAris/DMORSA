# Written by Mikova Valentina and Salavat Garifullin
# Create a collection of accounts, there are 10 consecutive numbers in each account. 
#Possible phone numbers are 100-999.

for i in {10..99}; do

_aid1=$(shuf -i 100000000000-999999999999 -n 1)
_aid2=$(shuf -i 100000000000-999999999999 -n 1)
accounts="$accounts"'{_aid:{"$oid": "'$_aid1$_aid2"},
phones:["$i"0,"$i"1,"$i"2,"$i"3,"$i"4,"$i"5,"$i"6,"$i"7,"$i"8,"$i"9]}"

done
