#! /usr/bin/env python

import pickle
import pandas as pd
import os

pd.options.display.float_format = '{:,.5f}'.format

df = pd.DataFrame()
workdir = os.getcwd()

ae = pd.read_csv(workdir+'/AE/dkh_p_2/tz.table1.csv', sep='\s*,\s*', engine='python')
df['AE'] = ae['CCSD'].values-ae['CCSD'].values[0]

pps=['uc', 'sbkjc', 'crenbl', 'lanl2', 'mdfstu', 'mwbstu','ECP1.0','ECP1.1', 'ECP1.2']

for pp in pps:
        ecp = pd.read_csv(workdir+'/'+pp+'/tz.table1.csv', sep='\s*,\s*', engine='python')
        df[pp] = ecp['CCSD'].values-ecp['CCSD'].values[0]

mad = pd.DataFrame(columns=df.columns)
diffs = 27.211386*df.copy()
#diffs=diffs[1:]   # Getting rid of ground state
#print(diffs)

#print("MADS")
for pp in pps:
        #print(pp)
        diffs[pp] = diffs[pp] - diffs['AE']
        mad.loc['MAD',pp]=diffs[pp].abs().mean()
        #print(diffs[pp].abs().mean())

print(diffs.to_latex())
print(mad.to_latex())
