#!/bin/bash -l
#SBATCH -J Tb_AE_4
#SBATCH -q premium
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 02:00:00
#SBATCH -o Tb_DKH.out

module load molpro

molpro -n 12 -s 3.com

