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


ecps = ['UC_arxiv','ECP18','ECP19','ECP20','ECP21','ECP17_arxiv']#, 'w3', 'w6', 'w9']#,'i0','i7', 'i6']#'sub0','smal-se3','se3','se4']
styles={
'UC_arxiv'        :{'label':'UC',     'color':'#ff0000','linestyle':'-'           },
'mdfstu'    :{'label':'MDFSTU', 'color':'#ff6600','linestyle':'--','dashes':(4,1)   },
'mwbstu'    :{'label':'MWBSTU', 'color':'#ff33cc','linestyle':'--','dashes':(4,1,1,1)   },
'crenbl'    :{'label':'CRENBL', 'color':'#2f4f4f','linestyle':'--','dashes':(6,3)   },
'sbkjc'     :{'label':'SBKJC',  'color':'#1e90ff','linestyle':'--','dashes':(2,1,8,1)   },
'lanl2'     :{'label':'LANL2',  'color':'#a52a2a','linestyle':'--','dashes':(1,1)   },
'ECP17_arxiv'          :{'label':'ECP17',   'color':'#009900','linestyle':'--','dashes':(8,1,1,1,1,1)},
'ECP18'          :{'label':'ECP18',   'color':'#8A3324','linestyle':'--','dashes':(8,1,1,1,1,1)},
'ECP19'          :{'label':'ECP19',   'color':'#E3CF57','linestyle':'--','dashes':(8,1,1,1,1,1)},
'ECP20'          :{'label':'ECP20',   'color':'#FF6103','linestyle':'--','dashes':(8,1,1,1,1,1)},
'ECP21'          :{'label':'ECP21',   'color':'#838B8B','linestyle':'--','dashes':(8,1,1,1,1,1)},
'ECP42'          :{'label':'ECP42',   'color':'#9400D3','linestyle':'--','dashes':(8,1,1,1,1,1)},
'ECP43'          :{'label':'ECP43',   'color':'#006400','linestyle':'--','dashes':(8,1,1,1,1,1)},
'ECP44'          :{'label':'ECP44',   'color':'#BF3EFF','linestyle':'--','dashes':(8,1,1,1,1,1)},
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
    df = pd.read_csv("AE_arxiv/tzbind", delim_whitespace=True)
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
    data.to_csv("GdH3_QZ.csv", sep=',', index=False)

    ax.axhspan(-0.043,0.043,alpha=0.25,color='gray')
    ax.axhline(0.0,color='black')
    ax.set_xlabel('Bond Length (\AA)')
    ax.set_ylabel('Discrepancy (eV)')
    for i,ecp in enumerate(ecps):
        x = data['r']
        y= (data[ecp] - data['ae'])*toev
        plt.plot(x,y,**styles[ecp])
    ax.set_xlim((1.40,2.60))
    ax.set_ylim((-0.08,0.08))
    ax.set(title='GdH3 QZ Discrepancies')
    #plt.legend(bbox_to_anchor=(0.53, 0.15, 0.5, 0.5), fontsize="x-small")
    plt.legend(loc='best',ncol=2,prop={'size': 15})
    plt.axvline(2.013892010337442,ls='--',color='gray',linewidth=1.0)
    plt.savefig('GdH3_QZ.pdf')
    plt.show()

if __name__ == '__main__':
    plot()
