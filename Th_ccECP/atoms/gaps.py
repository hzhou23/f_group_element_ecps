#! /usr/bin/env python

import pickle 
import pandas as pd
import numpy as np

###==================================================

#pps = ['UC', 'SBKJC', 'ccECP', 'hard_ccECP', 'n25.2', 'n38.1', 'n38.3', 'n40.0', 'n42.0', 'n42.2', 'n44.0', 'n45.2', 'n45.3', 'n47.0', 'n48.0', 'n49.1', 'n50.0', 'n50.1', 'n50.2', 'n50.4']
pps = ['UC', 'SBKJC', 'ccECP']
remove_index = []
lmad_index = [1,2,3,4,5,6]

###==================================================

toev = 27.211386245988
pd.options.display.float_format = '{:,.3f}'.format

df = pd.DataFrame()

ae = pd.read_csv("AE/3.csv", sep='\s*,\s*', engine='python')
df['AE'] = ae['CCSD'].values-ae['CCSD'].values[0]

for pp in pps:
	ecp = pd.read_csv(pp+'/3.csv', sep='\s*,\s*', engine='python')
	df[pp] = ecp['CCSD'].values-ecp['CCSD'].values[0]

### Drop some undesired states:
df = df.drop(index=remove_index)

diffs = df.copy()*toev
diffs = diffs[1:]  # Getting rid of ground state
ae_gaps = diffs['AE']  # Save AE values before subtracting
diffs = diffs.sub(ae_gaps, axis=0)

mad = diffs.copy().abs().mean()
diffs.loc['MAD'] = mad

lmad = diffs.copy().loc[lmad_index].abs().mean()
diffs.loc['LMAD'] = lmad

weight = np.sqrt(ae_gaps.abs())
wmad = diffs.copy().abs().div(weight, axis=0).mean()*100
diffs.loc['WMAD'] = wmad

diffs['AE'] = ae_gaps  # Revert back to AE gaps

### Sorting everything except AE
ecp_sorted = diffs.iloc[:,1:].sort_values(by="WMAD", ascending=False, axis=1)
final_sorted = pd.concat([diffs.iloc[:,0:1], ecp_sorted], axis=1)
#print(final_sorted)
print(final_sorted.to_latex())

### Write MADs for later analysis
spectral = final_sorted.loc["MAD":"WMAD"]
#spectral = spectral.rename(columns={"CRENBS":"CRENBL"}) # Specific to Bi only
spectral = spectral.T
spectral = spectral[1:] # Getting rid of AE
#print(spectral)
spectral.to_csv("Tb.csv", float_format="%.3f")

