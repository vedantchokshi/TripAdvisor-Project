#!/bin/bash

out=$(mktemp /tmp/output.XXX)
for f in $1/*
do
	hotelName=$(basename "$f" .dat)
	overallAverage=$(awk '
	BEGIN {
	FS=">"
	} {
		if("<Overall"==$1) {
			sum+=$2;
			++numOfReviews;
		}
	} END {
		printf "%.2f", sum / numOfReviews;
	}' $f)
	echo -e ${hotelName} "\t" ${overallAverage} >> $out
done
sort -k2nr $out
