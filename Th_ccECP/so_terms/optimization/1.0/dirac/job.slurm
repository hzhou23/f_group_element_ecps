#!/bin/bash -l
#SBATCH -J COSCI_OPT
#SBATCH -q premium
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 00:30:00
#SBATCH -o slurm.out

module load cmake
module load cray-hdf5

export HDF5_USE_FILE_LOCKING=FALSE
export DIRAC_TMPDIR=/global/cscratch1/sd/aannabe/DIRAC_SCRATCH
export OMP_NUM_THREADS=4

./calc.sh
