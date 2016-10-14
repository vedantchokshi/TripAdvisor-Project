#!/bin/bash

for f in reviews_folder/$1.dat reviews_folder/$2.dat
do
	nums+=$(awk '
	BEGIN {
        FS=">"
        } {
		if("<Overall"==$1) {
			n += 1;
			delta = $2 - mean;
			mean += delta / n;
			M2 += delta * (substr($0,10,1) - mean);
		}
	} END {
		print n;
		printf  mean " ";
		printf  M2 / (n-1) " ";
		printf sqrt(M2 / (n-1)) " ";
	}' $f)
done
array=($nums)

#array[0]=N Hotel 1
#array[1]=Mean Hotel 1
#array[2]=Variance Hotel 1
#array[3]=Standard Deviation Hotel 1
#array[4]=N Hotel 2 
#array[5]=Mean Hotel 2 
#array[6]=Variance Hotel 2 
#array[7]=Standard Deviation Hotel 2
tValue=$(echo "(${array[1]} - ${array[5]}) /sqrt((((${array[0]}-1)*${array[2]} + (${array[4]}-1)*${array[6]}) / (${array[0]} + ${array[4]} - 2)) * (1/${array[0]} + 1/${array[4]}))" | bc -l)

printf "t: %.2f\n" $tValue
printf  "Mean $1: %.2f, SD: %.2f\n" ${array[1]} ${array[3]}
printf  "Mean $2: %.2f, SD: %.2f\n" ${array[5]} ${array[7]}
echo $tValue'>'1.960 | bc -l
