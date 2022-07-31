#!/bin/bash -l
#SBATCH -J NUM_30.3
#SBATCH -q shared
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH -C haswell
#SBATCH -t 12:00:00
#SBATCH -o Tb_OPT.out
#SBATCH --mem=1GB

module purge
module load gcc
module load python/3.8-anaconda-2020.11
source activate nexus3 

export OMP_NUM_THREADS=1

date

rm SOQ.out log.out results.out 

make
./exe > log.out

rm SOQ.out log.out
cd ../opium_norm
rm *.pcc_plt

date

