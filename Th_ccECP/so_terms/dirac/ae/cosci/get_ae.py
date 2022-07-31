#! /usr/bin/env python

import sys,os
import numpy as np
import glob
import pandas as pd
from numpy import random

LAW = 100.0 # Largest Allowed Weight
CGEW = 1.0 # Charge Gap Effective Weight
#N_keep = 20 # Number of states to keep for SOC gaps

states = {
'gs'	:	16,
'f8s2d1':	14,
'f9s1'	:	17,
'f9'	:	16,
'f8d1'	:	14,
'f8p1'	:	12,
}
N_states = len(states)

toev=27.21138602
pd.options.display.float_format = '{:,.12f}'.format

def shift_row_to_top(df, index_to_shift):
	"""Shift row, given by index_to_shift, to top of df."""
	
	idx = df.index.tolist()
	idx.pop(index_to_shift)
	df = df.reindex([index_to_shift] + idx)
	df = df.reset_index(drop=True)
	
	return df


df = pd.DataFrame(columns=['gaps', 'degen'])
charge_gaps = pd.DataFrame(columns=['gaps', 'degen'])

### Extract the Gaps
for state in states:
	totals = pd.read_csv(state + '.dat',   delim_whitespace=True, index_col=False, header=None, engine='python') #sep='\s*&\s*',
	degen = pd.read_csv(state + '.degen', delim_whitespace=True, index_col=False, header=None, engine='python') #sep='\s*&\s*',
	so_gaps = pd.DataFrame(columns=['gaps', 'degen'])
	so_gaps['gaps'] = totals.iloc[:,0]
	so_gaps['degen'] = degen.iloc[:,0]

	### Check if the correct GS is obtained:
	for i in range(len(degen)):
		if so_gaps.loc[i, 'degen'] == states[state]:
			index_to_shift = i
			break
	so_gaps = shift_row_to_top(so_gaps, index_to_shift) # Shift the correct GS to top

	lowest_en = so_gaps.loc[0, 'gaps']
	lowest_deg = so_gaps.loc[0, 'degen']
	if state == 'gs':
		ref_en = lowest_en
	so_gaps['gaps'] = so_gaps['gaps'] - lowest_en
	#so_gaps = so_gaps.iloc[0:N_keep, :]
	so_gaps = so_gaps.sort_values(by=['degen', 'gaps'])
	df = df.append(so_gaps, ignore_index=True)
	my_gap = pd.DataFrame(data={'gaps' : [lowest_en - ref_en], 'degen' : [lowest_deg]})
	charge_gaps = charge_gaps.append(my_gap, ignore_index=True)

charge_gaps = charge_gaps.append(df, ignore_index=True)
df = charge_gaps
df['gaps'] = df['gaps'] * toev

ae_gaps = df['gaps'].values
#wei = 1/np.sqrt(np.abs(ae_gaps))
wei = 1/np.abs(ae_gaps**2)
wei[0:N_states] = wei[0:N_states] * CGEW
df['wei'] = wei
df = df.replace(np.inf, 0.0)
df.loc[df["wei"] > LAW, "wei"] = LAW
df.to_csv('ae.csv', sep='\t', float_format='%.12f', index=False)

