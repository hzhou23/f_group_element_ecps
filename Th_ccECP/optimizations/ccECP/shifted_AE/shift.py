#! /usr/bin/env python

import sys,os
import pandas as pd
import numpy as np

toev=27.21138602

#All energies are in Hartree
df = pd.read_csv("corr.dat", delim_whitespace=True)

df['AE_Corr'] = df['AE_CCSD'] - df['AE_SCF']
df['ECP_Corr'] = df['ECP_CCSD'] - df['ECP_SCF']

first_row = df.loc[0,:]
gaps = df.sub(first_row, axis=1)

gaps['Delta_Corr'] = gaps['AE_Corr'] - gaps['ECP_Corr']
gaps['AE_Shifted'] = gaps['AE_SCF'] + gaps['Delta_Corr']


print('Shifted AE Gaps [Ha] (for D2h OPT):')
print(gaps['AE_Shifted'])

gaps['Delta_code'] = gaps['SA_ECP_SCF'] - gaps['ECP_SCF']
gaps['AE_Shifted_SA'] = gaps['AE_Shifted'] + gaps['Delta_code']

print('Shifted AE Gaps [Ha] (for SA OPT):')
print(gaps['AE_Shifted_SA'])

print(gaps)
