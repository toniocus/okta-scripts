#!/bin/bash

if [ $# -ne 6 ] 
then 
	echo "usage: ./generateRepros.sh <lote num> <lote size> <account id> <initial msisdn> <initial imsi> <initial iccid>"
	echo "<initial msisdn> is a 10 digit number like 1000000030"
	echo "<initial imsi> is a 15 digit number like 100000000000030"
	echo "<initial iccid> is a 20 digit number like 10000000000000000030"
	exit
fi

LOTE_NUM=$1
LOTE_SIZE=$2
ACCOUNT_ID=$3
I_MSISDN=$4
I_IMSI=$5
I_ICCID=$6

DATE=$(date '+%Y%m%d%H%M%S')

CONTENT="{\"header\":{\"loteId\":\"$LOTE_NUM\",\"loteSize\":\"$LOTE_SIZE\",\"wholesaleId\":\"$ACCOUNT_ID\"},\"payload\":["

FILENAME="repro_request_"$LOTE_NUM"_"$LOTE_SIZE"_"$DATE".json"

echo $CONTENT > $FILENAME

echo "{\"msisdn\":\"$I_MSISDN\",\"imsi\":\"$I_IMSI\",\"iccid\": \"$I_ICCID\",\"ki\":\"5733FA6EFA97D873077AC8E15717A892\",\"offerId\": \"100147\",\"codLocalidad\":\"01299\",\"nroPuntoVentaFiscal\":\"91299\"}" >> $FILENAME

i=2
while [ $i -le $LOTE_SIZE ]
do
	NEW_MSISDN=$(($I_MSISDN + $i))
	NEW_IMSI=$(($I_IMSI + $i))
	NEW_ICCID=$(($I_ICCID + $i))
	echo ",{\"msisdn\":\"$NEW_MSISDN\",\"imsi\":\"$NEW_IMSI\",\"iccid\": \"$NEW_ICCID\",\"ki\":\"5733FA6EFA97D873077AC8E15717A892\",\"offerId\": \"100147\",\"codLocalidad\":\"01299\",\"nroPuntoVentaFiscal\":\"91299\"}" >> $FILENAME

	((i++))
done

echo "]}" >> $FILENAME
echo $FILENAME "created!"

exit
