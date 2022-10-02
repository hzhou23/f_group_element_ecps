#! /usr/bin/env python

import matplotlib
matplotlib.use('TkAgg')
import sys,os
import matplotlib.pyplot as plt
import matplotlib as mpl
import pandas as pd


#os.system("module load texlive")
#os.system("module load python")

toev=27.21138602

ecps = ['UC', 'crenbl', 'lanl2', 'mdfstu', 'mwbstu','sbkjc','ECP','ECP2','ECP3','ECP4','ECP5']#, 'w3', 'w6', 'w9']#,'i0','i7', 'i6']#'sub0','smal-se3','se3','se4']
styles = {
'UC'        :{'label': 'UC',       'color':'#8B3E2F','linestyle':'-','alpha':0.8},
'crenbl'    :{'label': 'CRENBL','color':'#ff7f00','linestyle':'-','alpha':0.5},
'lanl2'   :{'label': 'LANL2',    'color':'#377eb8','linestyle':'-','alpha':0.5 },
'mdfstu'    :{'label': 'MDFSTU',      'color':'#984ea3','linestyle':'-' ,'alpha':0.5 },
'sbkjc'     :{'label': 'SBKJC',    'color':'#00CDCD','linestyle':'-','alpha':0.5 },
#'sub0'       :{'label': 'Sub0',      'color':'#6600ff','linestyle':'--','dashes': (3,2)      },
'ECP4'     :{'label': 'ECP4',      'color':'#006666','linestyle':'--','dashes': (8,1,1,1,1,1)     },
#
'mwbstu'     :{'label': 'MWBSTU',      'color':'#008000','linestyle':'-','alpha':0.5     },
'ECP'      :{'label': 'ECP',    'color':'#e41a1c','linestyle':'--','dashes':   (8,1,1,1,1,1) },
'ECP2'      :{'label': 'ECP2',    'color':'#cc0099','linestyle':'--','dashes': (8,1,1,1,1,1) },
'ECP3'      :{'label': 'ECP3',    'color':'#39e600','linestyle':'--','dashes': (8,1,1,1,1,1) },
'ECP5'     :{'label': 'ECP5',      'color':'#4daf4a','linestyle':'-','dashes': (8,1,1,1,1,1)     },
}

def init():
    font = {'family' : 'serif',
            'size': 20}
    lines = {'linewidth':2.0}
    axes = {'linewidth': 3}
    tick = {'major.size': 5,
            'major.width':2}
    legend = {'frameon':False,
              'fontsize':18}

    mpl.rc('font',**font)
    mpl.rc('lines',**lines)
    mpl.rc('axes',**axes)
    mpl.rc('xtick',**tick)
    mpl.rc('ytick',**tick)
    mpl.rc('legend',**legend)

    mpl.rcParams['text.usetex'] = True
    mpl.rcParams.update({'figure.autolayout':True})
    fig = plt.figure()
    ax1 = fig.add_subplot(111)
    return fig,ax1

def get_data():
    data = pd.DataFrame()
    df = pd.read_csv("AE/tzbind", delim_whitespace=True)
    data['r']= df['r']
    data['ae']= df['bind']
    for ecp in ecps:
        df = pd.read_csv("%s/tzbind" % ecp, delim_whitespace=True)
        data[ecp] = df['bind']
    return data

def plot():
    fig,ax = init()
    data = get_data()
    #print data.head()
    data.to_csv("RhH_TZ.csv", sep=',', index=False)

    ax.axhspan(-0.05,0.05,alpha=0.25,color='gray')
    ax.axhline(0.0,color='black')
    ax.set_xlabel('Bond Length (\AA)')
    ax.set_ylabel('Discrepancy (eV)')
    for i,ecp in enumerate(ecps):
        x = data['r']
        y = (data[ecp] - data['ae'])*toev
        plt.plot(x,y,**styles[ecp])
    ax.set_xlim((1.10,2.10))
#    ax.set_ylim((-0.25,0.25))
    ax.set(title='RhH tz Discrepancies')
    #plt.legend(bbox_to_anchor=(0.53, 0.15, 0.5, 0.5), fontsize="x-small")
    plt.legend(loc='best',ncol=2,prop={'size': 15})
    plt.axvline(1.5412460997904909,ls='--',color='gray',linewidth=1.0)
    plt.savefig('RhH_TZ.pdf')
    plt.show()

if __name__ == '__main__':
    plot()

