
#! /usr/bin/env python

import sys,os
import pandas as pd
from scipy.optimize import curve_fit
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt


toev = 27.211386

#~~~Analyze Binding Energy~~~~~


binding = pd.read_csv("prebind", delim_whitespace=True)
ecpbinding = pd.read_csv("ECPprebind", delim_whitespace=True)
aebinding = pd.read_csv("AEtzbind", delim_whitespace = True)
#binding = binding.drop([0]).reset_index(drop=True)
#print binding
r=binding['r']
ae_r = aebinding['r']
bind = binding['bind']
ecpbind = ecpbinding['bind']
aebind = aebinding['bind']
#diff =( ecpbinding['bind'] - binding['bind']) * toev
fig=plt.figure()
ax=fig.add_subplot(111)
#ax.axhspan(-0.043,0.043, color = '#929591' ,alpha = 0.3)
#plt.axhline(0,ls='--',color='gray',linewidth=1.0)
#plt.plot(r,diff,color = 'r')
plt.plot(r, ecpbind, color = 'b' )
plt.plot(ae_r,aebind,color = 'k')
plt.plot(r,bind,color='r')
plt.savefig('prebind.pdf')

