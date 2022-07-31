#!/usr/bin/env bash

for ((i=1; i<=8; i++))
do
        echo ${i}
        cd ${i}

        tail -n 2 3.csv >> ../3.csv
        cd ../
done
