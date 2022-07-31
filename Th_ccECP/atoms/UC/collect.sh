#!/usr/bin/env bash

for ((i=1; i<=15; i++))
do
        echo ${i}
        cd ${i}

        tail -n 2 3.csv >> ../3.csv
        cd ../
done
