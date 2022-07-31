#!/bin/bash -l
#SBATCH -J Tb_ECP
#SBATCH -q premium
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 01:30:00
#SBATCH -o Tb_DKH.out

module use /global/common/software/nersc/cle7/extra_modulefiles
module load molpro

molpro -n 24 -s 3.com

