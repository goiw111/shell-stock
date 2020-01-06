#!/bin/bash

#category (name,info)
#suppliers (full_name,phone)
#brands (name,info)
#product (full_name,category_id,unit_in_pack,brand_id)

#product_suppliers (prod_id,splr_id)
#stock (prod_id,quantity,P_date,E_date,buy_price)
#prices (domain_id,value,stock_id)

NAME=""
INFO=""
PHON=""
CATG=""
UNIP=""
BRND=""
SPLR=""
PRDC=""
QUAN=""
PDAT=""
EDAT=""
BAYP=""
DMID=""
VALU=""
STCK=""


CMND_STATE=-1

CTGRY=0
BRNDS=1
SPLIR=2
PRDCT=3
STOCK=4

DBDIR=$HOME/.var/app/org.pos.manager/data/posman.db
REPHON='^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$'


usege(){
	echo "Usage: $0[ [ -n NAME ] 
	[ 
	///for add a category of brands
	[ -i INFO ] [ -c | -b ]
	///for add a supliers
	| -s [ -f phone ]
	///for add a product
	| -p [ -C CATEGORY ID ] [ -u UNIT IN PACK] [ -B BRAND ID ] [ -S SUPLIER ID ] 
	] ]
	or
	///for binding a prodect with supier
	[ -P PRODUCT ID ] [ -S SUPLIER ID ] 
	or
	///for add a prodect to stock
	[ -z [ -P PRODUCT ID ] [ -q QUANTITY ] [ -d PRO DATE ] [ -D EXT DATE ] [ -x BAY PRICE ] ]
	or
	///for add a price of a prodect
	[ -m DOMAIN ID] [ -v VALUE ] [ -Z STOCK ID ]
	" 1>&2 
}

exit_abnormal()
{
  usege
  exit 1
}

while getopts ":n:ci:sf:bpC:u:B:S:zP:q:d:D:x:m:v:Z:" options; do

	case "${options}" in
		n)NAME=${OPTARG};;
		i)INFO=${OPTARG};;
		f)PHON=${OPTARG};;
		C)CATG=${OPTARG};;
		u)UNIP=${OPTARG};;
		B)BRID=${OPTARG};;
		S)SPLR=${OPTARG};;
		P)PDID=${OPTARG};;
		q)QUIN=${OPTARG};;
		d)PDAT=${OPTARG};;
		D)EDAT=${OPTARG};;
		x)BAYP=${OPTARG};;
		c)CMND_STATE=$CTGRY;;
		b)CMND_STATE=$BRNDS;;
		s)CMND_STATE=$SPLIR;;
		p)CMND_STATE=$PRDCT;;
		z)CMND_STATE=$STOCK;;
		:)
		echo "Error: -${OPTARG} requires an argument."
		exit_abnormal
		;;
		*)exit_abnormal;;
		h)usege
		exit 0;;
	esac

done



if [ $CMND_STATE -eq -1 ]; then
	exit 1
	fi
case $CMND_STATE in
	$CTGRY)
		if [ -z $NAME ]; then
			echo "name is empty"
			exit 1
		fi
		if [ -z "$INFO" ]; then
			echo "info is empty"
			exit 1
		else
			echo -n "insert into category (name,info) values ('${NAME:-15}','${INFO:-30}');" | sqlite3 $DBDIR
		fi;;
	$BRNDS)
		if [ -z $NAME ]; then
			echo "name is empty"
			exit 1
		fi
		if [ -z "$INFO" ]; then
			echo "info is empty"
			exit 1
		else
			echo -n "insert into brands (name,info) values ('${NAME:-15}','${INFO:-30}');" | sqlite3 $DBDIR
			fi;;
	$SPLIR)
		if [ -z $NAME ]; then
			echo "name is empty"
			exit 1
		fi
		if [ -z $PHON ]; then
			echo "phone number is empty"
			exit 1
		fi
		if [[ ! $PHON =~ $REPHON ]]; then
			echo "this number not mached, pleas anter a phone number"
			exit 1
		else
			echo -n "insert into suppliers (full_name,phone) values ('${NAME:-15}','${PHON:-15}');" | sqlite3 $DBDIR
			fi;;
	$PRDCT)
		if [ -z $NAME ]; then
			echo "name is empty"
			exit 1
		fi
		if [ -z $UNIP ]; then
			echo "plase anter how much unit in pack"
			exit 1
		fi
		if [ -z $CATG ]; then
			echo "plase anter the catagory id with -C"
			exit 1
		fi
		if [ -z $BRID ]; then
			echo "plase anter the brand id with -B"
			exit 1
		fi
		if [ -z $SPLR ]; then
			echo "plase anter the suplier id with -S"
			exit 1
		fi;;
	$STOCK);;
esac
