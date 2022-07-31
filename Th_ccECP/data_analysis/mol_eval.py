#! /usr/bin/env python

import sys
import os
import numpy as np
import pandas as pd
from scipy.optimize import curve_fit
import uncertainties
from uncertainties import ufloat
from uncertainties import umath
from uncertainties import unumpy as unp
import matplotlib.pyplot as plt
import matplotlib as mpl
import string
import glob

###~~~~~~~~~~~~~~~~ Input ~~~~~~~~~~~~~~~~~~~~~~~

group = ['TbH3_TZ.csv','TbO_TZ.csv']

masses = pd.DataFrame(columns=['molecule','m1','m2'])
mass_H = 1.00794
mass_H3 = 1.00794*3
mass_O = 15.9994

masses.loc[len(masses)] = ['TbH3_TZ.csv', 158.92535,  mass_H3]
masses.loc[len(masses)] = ['TbO_TZ.csv',  158.92535,  mass_O]

masses = masses.set_index('molecule')
#print(masses)
#print(list(masses['molecule']))

###~~~~~~~~~~~~~~~ Constants ~~~~~~~~~~~~~~~~~~~~~~~

toev=27.21138602
bohr=0.52917721067      # Bohr to Angs
amu=1822.888486         # amu to au
tocm=2.194746313702e5
wconv=tocm*bohr/np.sqrt(amu)
#print wconv

####~~~~~~~~~~~~~ Functions ~~~~~~~~~~~~~~~~~~~~~~~~
def morse(x,D,a,re):
        y=D*(np.exp(-2*a*(x-re))-2*np.exp(-a*(x-re)))
        return y

umorse=uncertainties.wrap(morse)

def omega(D,a,mu):
        y=umath.sqrt(2*(a**2)*D/mu)
        return y

def rdis(re, a):        #Find dissaciation bond length
        y=re-unp.log(2)/a
        return y


class ShorthandFormatter(string.Formatter):
    def format_field(self, value, format_spec):
        if isinstance(value, uncertainties.UFloat):
            return value.format(format_spec+'S')  # Shorthand option added
        # Special formatting for other types can be added here (floats, etc.)
        else:
            # Usual formatting:
            return super(ShorthandFormatter, self).format_field(
                value, format_spec)
frmtr = ShorthandFormatter()

def unc1_to_latex(x):
	y = frmtr.format("{0:.1u}", x)
	return y

def unc2_to_latex(x):
	y = frmtr.format("{0:.2u}", x)
	return y

os.system("rm -rf properties")
os.system("mkdir properties")

for mol in group:
	### ~~~~~~~~ Prepare Dataframe ~~~~~~~~~~~
	print('Molecule:', mol)
	df = pd.read_csv("%s" % mol)
	#df = df.rename(columns={'MWBSTU':'MDFSTU'})
	df = df.rename(columns={'CRENBS':'CRENBL'})
	df = df.reindex(sorted(df.columns), axis=1)
	#print(df)
	
	m1 = masses.loc[mol,'m1']
	m2 = masses.loc[mol,'m2']
	#print(m1,m2)
	mu=m1*m2/(m1+m2)
	
	### ~~~~~~~~~~ Execute the Fit ~~~~~~~~~~~~~
	
	x1 = int(0)
	x2 = int(len(df)-1)
	#print(x1,x2)
	
	latex=pd.DataFrame(columns=df.columns,  index=["$D_e$(eV)", "$r_e$(\AA)", "$\omega_e$(cm$^{-1}$)", "$D_{diss}$(eV)"])
	del latex['z']
	#print(latex)
	
	
	for column in df:
		if column == "z":
			continue
		else:
			#print(column)
			index_middle = int((x1+x2)/2)
			initial=[-df[column].iloc[index_middle], 1.75, df['z'].iloc[index_middle] ]
			#print('Guess:', initial)
			popt_m, pcov_m = curve_fit(morse, df['z'].iloc[x1:x2], df[column].iloc[x1:x2], p0=initial)
			std=np.sqrt(np.diag(pcov_m))
			#print("popt_m:",popt_m)
			#print("STD:",std)
			D=ufloat(popt_m[0], std[0])
			a=ufloat(popt_m[1], std[1])
			re=ufloat(popt_m[2], std[2])
			w=omega(D,a,mu)
			
			#####~~~~~~~~~Plots~~~~~~~~~~~~~~~~~~~
			#x=np.linspace(df['z'].loc[0],df['z'].loc[len(df['z'])-1],50)
			#fig1, ax1 = plt.subplots()
			#plt.plot(df['z'], df[column], 'ko')
			#plt.plot(x, morse(x, *popt_m), 'b--', lw=1, label='Fitted function')
			#ax1.set(title='Fit',
			#xlabel='z',
			#ylabel='E(hartree)')
			#legend = ax1.legend(loc='best', shadow=False)
			#plt.show()
		
			if column=='AE':
				ae_D=D
				ae_re=re
				ae_w=w
				ae_rdis=rdis(re,a)
				#print("AE Dissaciation bond length:", ae_rdis)
				ae_Ddis=umorse(ae_rdis,D,a,re)
				#print("AE Binding energy at R_dis:",ae_Ddis)
				latex[column].iloc[0]=frmtr.format("{0:.1u}", D*toev)  # 1-digit uncertainty
				latex[column].iloc[1]=frmtr.format("{0:.1u}", re) 
				latex[column].iloc[2]=frmtr.format("{0:.2u}", w*wconv)  
				latex[column].iloc[3]=0.0
	
			else:
				latex[column].iloc[0]=frmtr.format("{0:.1u}", -(D-ae_D)*toev)   # - sign is there since Morse potential assumes positive D_e
				latex[column].iloc[1]=frmtr.format("{0:.1u}", re-ae_re)
				latex[column].iloc[2]=frmtr.format("{0:.2u}", (w-ae_w)*wconv)
				latex[column].iloc[3]=frmtr.format("{0:.2u}", (umorse(ae_rdis,D,a,re)-ae_Ddis)*toev)
				#print("ECP Binding energy at R_dis:", umorse(ae_rdis,D,a,re))
	
				# ~~~ Store the ECP discrepancies ~~~
				try:
					my_ecp=pd.read_pickle("properties/"+column+".pkl")
				except:
					my_ecp=pd.DataFrame(columns=["molecule","$D_e$(eV)", "$r_e$(\AA)", "$\omega_e$(cm$^{-1}$)", "$D_{diss}$(eV)"])
					
				index=len(my_ecp)
				my_ecp.loc[index,"molecule"]=mol
				my_ecp.loc[index,"$D_e$(eV)"]=(D-ae_D)*toev
				my_ecp.loc[index,"$r_e$(\AA)"]=re-ae_re
				my_ecp.loc[index,"$\omega_e$(cm$^{-1}$)"]=(w-ae_w)*wconv
				my_ecp.loc[index,"$D_{diss}$(eV)"]=(umorse(ae_rdis,D,a,re)-ae_Ddis)*toev
				#print(my_ecp)
				my_ecp.to_pickle("properties/"+column+".pkl")
	
	latex = latex.reset_index().iloc[:,1:]
	latex = latex.to_latex()
	print(latex)


#### ~~~~ Means ~~~~~

os.chdir('properties')
files=sorted(glob.glob("*.pkl"))
#print(files)

latex=pd.DataFrame(columns=["$D_e$(eV)", "$r_e$(\AA)", "$\omega_e$(cm$^{-1}$)", "$D_{diss}$(eV)"])
for core in files:
	#print(core)
	dfcore = pd.read_pickle(core)
	dfcore = dfcore.set_index('molecule')
	#print(dfcore)
	#print(unc_to_latex(dfcore.iloc[1,1]))
	npcore=np.array(dfcore.values)
	#print(npcore)
	#print(np.mean(np.absolute(npcore), axis=0))
	latex.loc[core]=np.mean(np.absolute(npcore), axis=0)

latex1 = latex.applymap(unc1_to_latex)
latex2 = latex.applymap(unc2_to_latex)
latex1 = latex1.to_latex()
latex2 = latex2.to_latex()
#print(latex1)
#print(latex2)
os.chdir('../')

