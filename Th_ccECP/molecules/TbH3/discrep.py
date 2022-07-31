#!/usr/bin/env python

import matplotlib.pyplot as plt
import matplotlib as mpl
import pandas as pd
import pickle
import sys

### === INPUTS ===

#ecps = ['UC', 'SBKJC', 'ccECP', 'hard-ccECP', 'n25.2', 'n38.1', 'n38.3', 'n40.0', 'n42.0', 'n42.2', 'n44.0', 'n45.2', 'n45.3', 'n47.0', 'n48.0', 'n48.1', 'n49.1', 'n50.0', 'n50.1', 'n50.4']
ecps = ['UC', 'SBKJC', 'ccECP']

styles={
'UC'	:{'label':'UC',    'color':'#ff0000','linestyle':'-'                       },
'SBKJC'	:{'label':'SBKJC', 'color':'#1e90ff','linestyle':'--','dashes':(2,1,8,1)   },
'ccECP'	:{'label':'ccECP', 'color':'#009933','linestyle':'--','dashes':(4,1)       },

'n25.2'         :{'label':'n25.2'},
'n38.1'         :{'label':'n38.1'},
'n38.3'         :{'label':'n38.3'},
'n40.0'         :{'label':'n40.0'},
'n42.0'         :{'label':'n42.0'},
'n42.2'         :{'label':'n42.2'},
'n44.0'         :{'label':'n44.0'},
'n45.2'         :{'label':'n45.2'},
'n45.3'         :{'label':'n45.3'},
'n47.0'         :{'label':'n47.0'},
'n48.0'         :{'label':'n48.0','linestyle':'--','dashes':(2,2)},
'n48.1'         :{'label':'n48.1','linestyle':'--','dashes':(2,2)},
'n49.1'         :{'label':'n49.1','linestyle':'--','dashes':(2,2)},
'n50.0'         :{'label':'n50.0','linestyle':'--','dashes':(2,2)},
'n50.1'         :{'label':'n50.1','linestyle':'--','dashes':(2,2)},
'n50.3'         :{'label':'n50.3','linestyle':'--','dashes':(2,2)},
'n50.4'         :{'label':'n50.4','linestyle':'--','dashes':(2,2)},
}


molecule_basis = "TbH3_TZ"
Req=2.007

### =============

def init():
    font   = {'family' : 'serif', 'size': 17}
    lines  = {'linewidth': 2.5}
    axes   = {'linewidth': 2.0}    # border width
    tick   = {'major.size': 2, 'major.width':2}
    legend = {'frameon':True, 'fontsize':15.0, 'handlelength':2.40, 'labelspacing':0.30, 'handletextpad':0.4, 'loc':'best', 'facecolor':'white', 'framealpha':1.00, 'edgecolor':'#f2f2f2'}
    mpl.rc('font',**font)
    mpl.rc('lines',**lines)
    mpl.rc('axes',**axes)
    mpl.rc('xtick',**tick)
    mpl.rc('ytick',**tick)
    mpl.rc('legend',**legend)
    mpl.rcParams['text.usetex'] = True
    mpl.rcParams.update({'figure.autolayout':True})
    fig = plt.figure()
    fig.set_size_inches(7.36, 5.52)   # Default 6.4, 4.8
    ax1 = fig.add_subplot(111) # row, column, nth plot
    ax1.tick_params(direction='in', length=6, width=2, which='major', pad=6)
    ax1.tick_params(direction='in', length=4, width=1, which='minor', pad=6)
    ax1.grid(b=None, which='major', axis='both', alpha=0.10)

    return fig, ax1

def get_data():
	ae = pd.read_csv('AE/bind.csv',sep=',', index_col='z')
	dfs = pd.DataFrame()
	for ecp in ecps:
		df = pd.read_csv(ecp+'/bind.csv',sep=',')
		dfs[ecp] = df['bind']
	dfs = dfs.set_index(ae.index)
	#ha = dfs.copy()
	#ha.index = ae.index
	#ha['ae'] = ae['bind']
	#ha.to_csv('BiO_TZ.csv', float_format = "%.6f")
	return ae,dfs

def write_data(name):
	ae = pd.read_csv('AE/bind.csv',sep=',', index_col='z')
	dfs = pd.DataFrame()
	for ecp in ecps:
		df = pd.read_csv(ecp+'/bind.csv',sep=',')
		dfs[ecp] = df['bind']
	dfs = dfs.set_index(ae.index)
	dfs['AE'] = ae['bind']
	dfs.to_csv(name, float_format = "%.6f")
	return dfs


def plot(r0=None):
	fig,ax = init()
	ae,ecps = get_data()

	ax.grid(b=None, which='major', axis='both', alpha=0.1)
	ax.tick_params(direction='in', length=5.0)
	ax.axhspan(-0.043,0.043,alpha=0.25,color='gray')
	ax.axhline(0.0,color='black')
	ax.set_xlabel('Bond Length (\AA)')
	ax.set_ylabel('Discrepancy (eV)')
	for i,ecp in enumerate(ecps):
		x = ecps.index.values
		y = (ecps[ecp].values - ae['bind'].values)*27.211386245988
		plt.plot(x,y,**styles[ecp])
	ax.set_xlim((x[0],x[-1]))
	if r0:
		ax.axvline(r0,color='black',linestyle='--',linewidth=1.5,dashes=(2,2))
	else:
		ax.axvline(Req, color='black',linestyle='--',linewidth=1.5,dashes=(2,2))
	plt.legend(loc='best', ncol=1)
	plt.savefig(molecule_basis + ".pdf")
	plt.show()

if __name__ == '__main__':
	if len(sys.argv) == 2:
		plot(r0=float(sys.argv[1]))
		write_data(molecule_basis + ".csv")
	else:
		plot()
		write_data(molecule_basis + ".csv")

