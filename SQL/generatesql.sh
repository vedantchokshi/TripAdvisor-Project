#!/bin/bash

#Create empty file
> hotelreviews.sql

#Write 'create table' command into file
echo "CREATE TABLE HotelReviews(ReviewID INTEGER PRIMARY KEY, HotelID INT, URL TEXT, Overall INT, AvgPrice INT, Author TEXT, 
Content TEXT, DateCreated TEXT, NumOfReaders INT, NumFoundHelpful INT, OverallReview INT, MoneyValue INT, Rooms INT, Location INT, Cleanliness INT,
CheckIn INT, Service INT, BusinessService INT);" >> hotelreviews.sql 

for hotel in $1/*;
do
	# get hotel name
	hotelName=$(basename $hotel .dat)
	# pass bash variables into awk command
	awk -v hotelName=$hotelName 'BEGIN {
		#Split line
		FS=">";
		#Intialise variables
		Overall=NULL;
		AvgPrice=NULL;
		URL=NULL;
		Author=NULL;
		Content=NULL;
		DateCreated=NULL;
		NumOfReaders=NULL;
		NumFoundHelpful=NULL;
		OverallReview=NULL;
		MoneyValue=NULL;
		Rooms=NULL;
		Location=NULL;
		Cleanliness=NULL;
		CheckIn=NULL;
		Service=NULL;
		BusinessService=NULL;
		#Remove "hotel_" so only HotelID is entered into SQL
		gsub("hotel_","",hotelName)
		linestart=sprintf("INSERT INTO HotelReviews(HotelID,URL,Overall,AvgPrice,Author,Content,DateCreated,NumOfReaders,NumFoundHelpful,OverallReview,MoneyValue,Rooms,Location,Cleanliness,CheckIn,Service,BusinessService) VALUES(%s,", hotelName)
	} {
		if ($1 == "<Overall Rating"){ #Store Overall Rating
			Overall=$2
			getline
		}

		if ($1 == "<Avg. Price"){ #Store Average Price
			AvgPrice=$2
			gsub("Unkonwn","NULL",AvgPrice)
			gsub(/[$]/,"",AvgPrice)
			gsub(",","",AvgPrice)
			getline
		}

		if ($1 == "<URL"){ #Store URL
			URL=$2
			getline
		}
		
		if ($1 == "<Author"){ #Store Author
			Author=$2
			getline
		}
		
		if ($1 == "<Content"){ #Store Content
			Content=$2
			gsub("\"",/[\"]/,Content)
			getline
		}
		
		if ($1 == "<Date"){ #Store Date
			DateCreated=$2
			gsub(",","",DateCreated)
			getline
		}
		
		if ($1 == "<No. Reader"){ #Store Number of Readers
			if ($2 == -1) {
				NumOfReaders="NULL"
			} else {
				NumOfReaders=$2
			}
			getline
		}
		
		if ($1 == "<No. Helpful"){ #Store Number Of Helpful
			if ($2 == -1) {
				NumFoundHelpful="NULL"
			} else {
				NumFoundHelpful=$2
			}
			getline
		}
		
		if ($1 == "<Overall"){ #Store Overall
			if ($2 == -1) {
				OverallReview="NULL"
			} else {
				OverallReview=$2
			}
			getline
		}
		
		if ($1 == "<Value"){ #Store Value for Money
			if ($2 == -1) {
				MoneyValue="NULL"
			} else {
				MoneyValue=$2
			}
			getline
		}
		
		if ($1 == "<Rooms"){ #Store Room Rating
			if ($2 == -1) {
				Rooms="NULL"
			} else {
				Rooms=$2
			}
			getline
		}
		
		if ($1 == "<Location"){ #Store Location Rating
			if ($2 == -1) {
				Location="NULL"
			} else {
				Location=$2
			}
			getline
		}
		
		if ($1 == "<Cleanliness"){ #Store Cleanliness Rating
			if ($2 == -1) {
				Cleanliness="NULL"
			} else {
				Cleanliness=$2
			}
			getline
		}
		
		if ($1 == "<Check in / front desk"){ #Store Check in / front desk Rating
			if ($2 == -1) {
				CheckIn="NULL"
			} else {
				CheckIn=$2
			}
			getline
		}
		
		if ($1 == "<Service"){ #Store Service Rating
			if ($2 == -1) {
				Service="NULL"
			} else {
				Service=$2
			}
			getline
		}
		
		if ($1 == "<Business service"){ #Store Business service Rating
			if ($2 == -1) {
				BusinessService="NULL"
			} else {
				BusinessService=$2
			}
			#Print the formatted line
			printf("%s \"%s\", %s, %s, \"%s\", \"%s\", \"%s\", %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);\n", linestart,URL,Overall,AvgPrice,Author,Content,DateCreated,NumOfReaders,NumFoundHelpful,OverallReview,MoneyValue,Rooms,Location,Cleanliness,CheckIn,Service,BusinessService)
		}
	}' $hotel >> hotelreviews.sql
done
