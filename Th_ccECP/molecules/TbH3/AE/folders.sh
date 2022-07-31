#!/usr/bin/env bash

for ((i=9; i<=10; i++))
do
        echo ${i}
        mkdir ${i}
        cp 3.com ${i}
        cp job.slurm ${i}
        cd ${i}
        sed -i "s/my_state/${i}/g" 3.com
        sed -i "s/my_state/${i}/g" job.slurm
        sbatch job.slurm

        #tail 3.csv >> ../3.csv
        cd ../
done
