#! /usr/bin/env python

import sys,os
import numpy as np
import glob
import pandas as pd
from numpy import random


toev=27.21138602
pd.options.display.float_format = '{:,.9f}'.format
os.system("rm totals.out")
os.system("rm eigen.out")
os.system("rm results.out")
os.system("rm norm.out")
os.system("bash norm.sh")

N=[

"GS_5s2_5p6_6s2_4f9.d",
"EX_5s2_5p6_6s2_4f8_5d1.d",
"EX_5s2_5p6_6s1_4f8_5d2.d",
"EX_5s2_5p6_6s2_4f8_6p1.d",
"IP1_5s2_5p6_6s1_4f9.d",
"IP1_5s2_5p6_6s1_4f8_5d1.d",
"IP1_5s2_5p6_6s2_4f8.d",
"IP2_5s2_5p6_4f9.d",
"IP2_5s2_5p6_4f8_5d1.d",
"IP2_5s2_5p6_6s1_4f8.d",
"IP3_5s2_5p6_4f8.d",
"IP3_5s2_5p6_4f7_5d1.d",
"IP3_5s2_5p6_6s1_4f7.d",
"IP4_5s2_5p6_4f7.d",
"IP7_5s2_5p3_4f7.d",

]

os.system("cp pp.d ../yoon/.")
for i in N:
    print(i)
    os.system("cp %s ../yoon/ip.d" % i)
    os.chdir("../yoon")
    if i=="EX_5s2_5p6_6s2_4f8_5d1.d":
        os.system("timeout 3 ./a.out > gs.out")
        os.system("cat gs.out | grep 'TOTAL ENERGY' | awk '{print $4}' >> ../inputs/totals.out")
        os.system("cat gs.out | grep 'TOTAL ENERGY' | awk '{print $4}' >> ../inputs/eigen.out")
        os.system("cat gs.out | grep '1   0 0   0/2   1    2.0000' | awk '{print $7}' >> ../inputs/eigen.out")
        os.system("cat gs.out | grep '2   0 0   0/2   1    2.0000' | awk '{print $7}' >> ../inputs/eigen.out")
        os.system("cat gs.out | grep '2   1 1   2/2   1    2.0000' | awk '{print $7}' >> ../inputs/eigen.out")
        os.system("cat gs.out | grep '3   2 2   4/2   1    1.0000' | awk '{print $7}' >> ../inputs/eigen.out")
        os.system("cat gs.out | grep '4   3 3   6/2   1    2.0000' | awk '{print $7}' >> ../inputs/eigen.out")
    elif i=="IP3_5s2_5p6_4f7_5d1.d":
        os.system("timeout 3 ./a.out > gs.out")
        os.system("cat gs.out | grep 'TOTAL ENERGY' | awk '{print $4}' >> ../inputs/totals.out")
        os.system("cat gs.out | grep '1   0 0   0/2   1    2.0000' | awk '{print $7}' >> ../inputs/eigen.out")
        os.system("cat gs.out | grep '2   1 1   2/2   1    2.0000' | awk '{print $7}' >> ../inputs/eigen.out")
        os.system("cat gs.out | grep '3   2 2   4/2   1    1.0000' | awk '{print $7}' >> ../inputs/eigen.out")
        os.system("cat gs.out | grep '4   3 3   6/2   1    1.0000' | awk '{print $7}' >> ../inputs/eigen.out")
    else:
        os.system("timeout 3 ./a.out | grep 'TOTAL ENERGY' | awk '{print $4}' >> ../inputs/totals.out")
    os.chdir("../inputs")

### NORM
os.chdir("../opium_norm")
os.system("timeout 3 opium Tb Tb.log ps nl rpt")
os.system("sed -i 's/\t/    /g' Tb.rpt")

os.system("cat Tb.rpt | grep '100      2.000' | awk '{print $4}' >> ../inputs/norm.out")
os.system("cat Tb.rpt | grep '210      6.000' | awk '{print $4}' >> ../inputs/norm.out")
os.system("cat Tb.rpt | grep '320      2.000' | awk '{print $4}' >> ../inputs/norm.out")
os.system("cat Tb.rpt | grep '430      7.000' | awk '{print $4}' >> ../inputs/norm.out")
os.system("cat Tb.rpt | grep '200      0.000' | awk '{print $4}' >> ../inputs/norm.out")
os.system("cat Tb.rpt | grep '310      0.000' | awk '{print $4}' >> ../inputs/norm.out")

os.chdir("../inputs")

ae_gaps = np.array([
### Eigenvalues

# EX

-125.16914881 + (-122.449891--122.4818454), # total

-2.2948 + (-2.238795--2.2313), # s
-0.1998 + (-0.199814--0.1976), # s
-1.2872 + (-1.327864--1.3409), # p
-0.2468 + (-0.238855--0.2697), # d
-0.8547 + (-0.712529--0.7556), # f

## IP3

#-123.71139743 + (-121.072534--121.07481094), # total

-3.3795 + (-3.311165--3.3109), # s
-2.3062 + (-2.354677--2.3521), # p
-1.1853 + (-1.199080--1.2039), # d
-2.1064 + (-1.989653--1.9936), # f


#### Totals

 -0.137292,
 -0.136792,
 -0.081274,
  0.174409,
  0.042098,
  0.067109,
  0.567795,
  0.465824,
  0.492273,
  1.181092,
  1.260296,
  1.418212,
  2.442408,
 11.971204,

#### AE NORMs
0.6046735059,
0.6030224855,
0.6639163316,
0.6975501357,
0.6131147314,
0.6629784561,

])

try:
    tot = pd.read_csv("totals.out", delim_whitespace=True, index_col=False, header=None, engine='python') #sep='\s*&\s*',
    tot = tot.subtract(tot.iloc[0,0], axis='rows')
    tot = tot.drop([0])
    #print(tot)
    eig = pd.read_csv("eigen.out",  delim_whitespace=True, index_col=False, header=None, engine='python') #sep='\s*&\s*',
    ##print(eig)
    norm = pd.read_csv("norm.out",  delim_whitespace=True, index_col=False, header=None, engine='python') #sep='\s*&\s*',
    ##print(norm)
    
    ecp = pd.concat([eig, tot, norm], ignore_index=True)
    #ecp = eig
    #print(ecp)
except:
    x = random.uniform(0.5, 1) * 5
    err = np.ones(len(ae_gaps)) * x
    ecp = pd.DataFrame(err)

wei = np.ones(len(ae_gaps))
#wei = 1/np.sqrt(np.abs(ae_gaps))

wei[0:10] = 0.10 # All eigenvalues
wei[0]  = 1.e-3

wei[1]  = 1.00 # S semi-core eigenvalue
wei[2]  = 1.00 # S eigenvalue
wei[3]  = 1.00 # P semi-core eigenvalue
wei[4]  = 0.15 # D eigenvalue
wei[5]  = 0.25 # F eigenvalue


wei[6]  = 1.00 # S semi-core eigenvalue
wei[7]  = 2.00 # P semi-core eigenvalue


wei[10:16]  = 2.00 # Small gaps (Neutral and Charge=1)
wei[16:20] = 1.00 # Medium gaps (Charge=2) + IP3
wei[20:22] = 0.10 # Large gaps (Charge=3)
wei[22] = 0.05 # IP4
wei[23] = 0.01 # IP7

wei[24] = 0.50 # S Norms
wei[25] = 2.00 # P Norms
wei[26] = 0.15 # D Norms
wei[27] = 0.25 # F Norms
wei[28] = 0.05 # S Norms
wei[29] = 0.05 # P Norms

df = pd.DataFrame(columns=['ae', 'ecp', 'wei'])
df['ae'] = ae_gaps
df['wei'] = wei
df['ecp'] = ecp.iloc[:,0]
df['res'] = (df['ae'] - df['ecp'])*df['wei']*toev
print(df)
res = np.array(df['res'].values)
print('SOQ:', np.linalg.norm(res)**2)

results = df.drop(columns=['ae', 'ecp', 'wei']).transpose()
results = results.fillna(value=1e3)
#print(results)

results.to_csv('results.out', sep=' ', header=False, index=False)

