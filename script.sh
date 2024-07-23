#!/bin/sh

read -r c < counter

i=0
while [ "$i" -lt 5 ]; do
   if ping -c 1 -w 10 1.1.1.1 > /dev/null 2>&1; then
      #echo "$(date -I'seconds') Internet connection OK"
      c=0
      echo $c > counter
      exit 0
   fi
   i=$((i+1))
done

echo "$(date -I'seconds') Internet connection FAIL" >&2

if [ "$c" -gt 0 ]; then
   c=$((c - 1))
   echo $c > counter
   exit 0
else
   c=4
   echo $c > counter
fi

echo "$(date -I'seconds') Resetting router" >&2

mosquitto_pub -L mqtt://"$USERNAME":"$PASSWORD"@mosquitto:1883/zwave/nodeID_2/37/0/targetValue/set -m false

sleep 2

mosquitto_pub -L mqtt://"$USERNAME":"$PASSWORD"@mosquitto:1883/zwave/nodeID_2/37/0/targetValue/set -m true

exit 0

