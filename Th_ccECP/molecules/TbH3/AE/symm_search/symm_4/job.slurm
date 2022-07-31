#!/bin/bash -l
#SBATCH -J TbH_my_state
#SBATCH -q premium
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 00:30:00
#SBATCH -o Tb_DKH.out

module load molpro

molpro -n 12 -s 3.com

