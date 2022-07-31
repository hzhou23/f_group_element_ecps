#!/bin/bash -l
#SBATCH -J opt_Tb
#SBATCH -q premium
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 24:00:00
#SBATCH -o slurm.out

module load gcc
module load cmake
module load cray-hdf5
module load python/3.8-anaconda-2020.11
source activate nexus3 

export HDF5_USE_FILE_LOCKING=FALSE
export DIRAC_TMPDIR=/global/cscratch1/sd/aannabe/DIRAC_SCRATCH
export OMP_NUM_THREADS=4

date

rm SOQ.out results.out log.out

make
./exe > log.out

rm SOQ.out log.out

date

