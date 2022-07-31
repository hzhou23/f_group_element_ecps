#! /usr/bin/env python

import sys,os
import numpy as np
import glob
import pandas as pd
from numpy import random

toev=27.21138602
pd.options.display.float_format = '{:,.12f}'.format

os.system("rm results.out")
#os.system("bash calc.sh")
os.system("python get_ecp.py")


ae = pd.read_csv("ae.csv", sep='\t', index_col=False, engine='python')
ecp = pd.read_csv("ecp.csv", sep='\t', index_col=False, engine='python')

ae['res'] = (ae['gaps'] - ecp['gaps']) * ae['wei']
res = np.array(ae['res'].values)
print('NORM:', np.linalg.norm(res)**2)

results = ae.drop(columns=['gaps', 'degen', 'wei']).transpose()
results = results.fillna(value=1e3)
results.to_csv('results.out', sep=' ', header=False, index=False)

