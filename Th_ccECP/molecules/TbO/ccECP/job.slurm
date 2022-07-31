#!/bin/bash -l
#SBATCH -J TbO
#SBATCH -q premium
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 05:00:00
#SBATCH -o Tb_DKH.out

module use /global/common/software/nersc/cle7/extra_modulefiles
module load molpro

molpro -n 24 -s 3.com

