import sys, os
from pyscf import gto, scf, cc, dft
from pyscf.cc import uccsd_t
import numpy as np
import pandas as pd

workdir = os.path.dirname(os.path.realpath(__file__))
print(workdir)
Gd_basfile = os.path.join(workdir,'basis')
print(Gd_basfile)

mol = gto.Mole()
mol.atom = '''
Gd 0.0000  0.0000  0.0000; 
'''
mol.unit = 'Angstorm'
mol.basis = {'Gd': gto.load(Gd_basfile,'Gd')}
mol.symmetry =True
mol.spin = 8
mol.verbose = 5
mol.charge = 0
mol.build()


hf = scf.RHF(mol)
#hf.irrep_nelec = {
#'Ag' : (9,9),   # s
#'B3u': (6,4),   # x    1
#'B1u': (6,4),   # z    0
#'B2u': (6,4),   # y   -1
#'B2g': (2,2),   # xz   1
#'B3g': (2,2),   # yz  -1
#'B1g': (2,2),   # xy  -2
##'Au' : (0,0)    # xyz
#}
hf.max_cycle = 300
hf.verbose=5
#dm=hf.init_guess_by_chkfile('./pbe-triplet.chkfile')
hf.chkfile='Gd.chkfile'

hf.kernel()

hf.analyze()

