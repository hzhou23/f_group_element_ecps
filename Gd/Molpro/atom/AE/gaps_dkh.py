import numpy as np

import matplotlib
#matplotlib.use('TkAgg')
from scipy.optimize import curve_fit
import matplotlib.pyplot as plt
import os,sys
import pandas as pd

ai = 1.0
bi = 1.0
toev = 27.211386


df=pd.DataFrame()

for basis in ['tz']:
        x = pd.read_csv('./dkh/'+basis+'.table1.csv',skip_blank_lines=True,skipinitialspace=True)
        df[basis+'_scf'] = x['SCF']

scf = df.filter(regex='scf')

hf = pd.DataFrame()





hf['Molpro dkh'] = scf['tz_scf']
hf['bas. Gaps'] = hf['Molpro dkh'].values - hf['Molpro dkh'].values[0]
x = pd.read_csv('./numericalHF/spect_sr.out',skip_blank_lines=True)
y = pd.read_csv('./numericalHF/yoon-fchan/aeenergy_sr.out', skip_blank_lines = True)
hf['NumericalHF'] = y['SCF']
hf['Num. Gaps'] = x['SCF']
hf['Gap Diffs'] = (hf['bas. Gaps'] - hf['Num. Gaps'])*toev


print(hf.to_latex(index=False))
