
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
print (binding, ecpbinding)
#binding = binding.drop([0]).reset_index(drop=True)
#print binding
r=binding['r']
bind = binding['bind']
ecpbind = ecpbinding['bind']
fig=plt.figure()
ax=fig.add_subplot(111)

plt.plot(r,bind)
plt.plot(r,ecpbind,color = 'r')
plt.savefig('prebind.pdf')

