#!/usr/bin/env python

from nexus import settings,job,run_project
from nexus import generate_physical_system
from nexus import generate_pwscf
from nexus import generate_pw2qmcpack
from nexus import generate_qmcpack,loop,linear,vmc,dmc
from nexus import bundle
from nexus import ppset,obj
from structure import *

espresso_path='/ccs/proj/mat151/opt/qe_7.0_cmake/build_mpi/bin/pw.x'
box_length = 10.0   # Angstrom

settings(
    pseudo_dir    = 'pseudo',
    results       = '',
    runs          = 'runs',
    status_only   = 0,      
    generate_only = 0,
    sleep         = 5,      # In seconds
    machine       = 'andes', # Use lowercase letters
    account       = 'MAT151',  # QMCPACK
    user          = 'aannabe'
    )

scf_presub = '''
module load intel
module load hdf5/1.10.7
module load fftw/3.3.8
module load netlib-lapack
module load python
module list
'''

scf_postsub = '''
###rm -rf pwscf_output
'''

system = generate_physical_system(
    units     = 'A',
    #DIRECT LATTICE VECTORS CARTESIAN COMPONENTS (ANGSTROM)
    axes      = [
		[box_length, 0.0, 0.0],
		[0.0, box_length, 0.0],
		[0.0, 0.0, box_length]
                ],
    elem      = ['Tb'],  # positions below should correspond to this
    # CARTESIAN COORDINATES - PRIMITIVE CELL
    pos=[[box_length/2.0, box_length/2.0, box_length/2.0],],
    #tiling    = [[-1, 1, 1], [ 1,-1, 1], [ 1, 1,-1]],
    tiling    = (1,1,1),
    #use_prim  = True,
    #add_kpath = True,
    Tb        = 19,
    kgrid  = (1,1,1),
    kshift = (0,0,0),
    net_spin = 7
    )

sims = []

for ecut in range(700, 800, 100): # Min, Max, Step
	scf = generate_pwscf(
	    identifier   = 'scf',
	    path         = str(ecut),
	    job          = job(nodes=4, processes_per_node=8, cores_per_node=32, threads=4, hyperthreads=1, queue='debug', hours=2.0, presub=scf_presub, postsub=scf_postsub),
	    input_type   = 'generic',
	    calculation  = 'scf',
	    nspin        = 2,   # 1 is non-polarized calculation (default)
	    input_dft    = 'pbe', 
	    #hubbard_u    = obj(Tb=3.0),
	    #exx_fraction = 0.05,
	    #nqx1         = 2,
	    #nqx2         = 2,
	    #nqx3         = 2,
	    ecutwfc      = ecut,   
	    #ecutfock     = 425,
	    occupations  = 'fixed',
	    #occupations  = 'smearing',
	    #smearing     = 'gaussian',
	    #degauss      = 1e-3,
	    nosym        = True, # should be False if nscf is next
	    system       = system,
	    nbnd         = 20,       # a sensible nbnd value can be given 
	    tot_magnetization = 7,
	    tot_charge   = 0,
	    start_mag = {"Tb": 0.2,},
	    pseudos      = ['Tb.upf'],
	    max_seconds  = 2*3600 - 300,
	    #restart_mode = 'restart',
	
	    conv_thr     = 1e-6, 
	    mixing_beta     = 0.2,
	    electron_maxstep = 1000,
	    #mixing_mode     = 'local-TF',
	    #diago_full_acc  = True,
	    )
	sims.append(scf)

run_project(sims)

