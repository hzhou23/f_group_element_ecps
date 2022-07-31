#!/bin/bash -l
#SBATCH -J spin_1
#SBATCH -q debug
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 00:30:00
#SBATCH -o Tb_DKH.out

module load molpro

molpro -n 12 -s 3.com

