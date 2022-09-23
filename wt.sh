#!/bin/bash
touch tmp1
touch tmp2
touch history
git init
git add history
while [ true ]
do
    lynx -dump $1 > tmp1
    sleep $2
    lynx -dump $1 > tmp2
    diff tmp1 tmp2 > history
    git commit -m history > /dev/null
    cat /dev/null > tmp1
    cat /dev/null > tmp2
done

