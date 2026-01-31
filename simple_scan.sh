#!/usr/bin/env bash

subnet="192.168.1."

for i in $(seq 1 254)
do
  condition=$(ping -c 1 -W 2 "$subnet$i" | grep "bytes from")
  if [[ -z "$condition" ]]
  then
    echo "$subnet$i is down"
  else
    echo "$subnet$i is up"
  fi
done
