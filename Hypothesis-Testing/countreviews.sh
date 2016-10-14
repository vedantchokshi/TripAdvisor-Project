#!/bin/bash

out=$(mktemp /tmp/countreviews.XXX)
for f in $1/*
do
	hotelName=$(basename "$f" .dat)
	numOfReviews=$(grep -c "<Author>" $f)
	echo -e $hotelName "\t" $numOfReviews >> $out
done
sort -k2nr $out
