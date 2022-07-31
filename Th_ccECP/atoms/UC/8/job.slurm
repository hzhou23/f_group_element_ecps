#!/bin/bash -l
#SBATCH -J Tb_UC_8
#SBATCH -q regular
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 00:05:00
#SBATCH -o Tb_DKH.out

module load molpro

molpro -n 12 -s 3.com

