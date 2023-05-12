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

ecps = [ 'mwbstu','ECP612']#, 'w3', 'w6', 'w9']#,'i0','i7', 'i6']#'sub0','smal-se3','se3','se4']
styles={
'UC46'      :{'label':'UC46',       'color':'#ff0000','linestyle':'-'           },
'UC60'  :{'label':'UC60',   'color':'#ff6600','linestyle':'--','dashes':(4,1)   },
'mwbstu'    :{'label':'MWBSTU', 'color':'#ff33cc','linestyle':'--','dashes':(4,1,1,1)   },
'ECP611'    :{'label':'ECP21',  'color':'#2f4f4f','linestyle':'--','dashes':(6,3)   },
'ECP612'        :{'label':'ECP22',  'color':'#1e90ff','linestyle':'--','dashes':(2,1,8,1)   },
'ECP605'        :{'label':'ECP15',  'color':'#a52a2a','linestyle':'--','dashes':(1,1)   },
'ECP607'            :{'label':'ECP17',  'color':'#009900','linestyle':'--','dashes':(8,1,1,1,1,1)},
'ECP620'          :{'label':'ECP30',   'color':'#8A3324','linestyle':'--','dashes':(8,1,1,1,1,1)},
'ECP609'          :{'label':'ECP19',   'color':'#00FFFF','linestyle':'--','dashes':(8,1,1,1,1,1)},
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
    data.to_csv("LuO_TZ.csv", sep=',', index=False)

    ax.axhspan(-0.043,0.043,alpha=0.25,color='gray')
    ax.axhline(0.0,color='black')
    ax.set_xlabel('Bond Length (\AA)')
    ax.set_ylabel('Discrepancy (eV)')
    for i,ecp in enumerate(ecps):
        x = data['r']
        y= (data[ecp] - data['ae'])*toev
        plt.plot(x,y,**styles[ecp])
    ax.set_xlim((1.60,2.20))
#    ax.set_ylim((-0.25,0.25))
    ax.set(title='LuO qz Discrepancies')
    #plt.legend(bbox_to_anchor=(0.53, 0.15, 0.5, 0.5), fontsize="x-small")
    plt.legend(loc='best',ncol=2,prop={'size': 15})
    plt.axvline(1.7956041773868445,ls='--',color='gray',linewidth=1.0)
    plt.savefig('LuO_TZ.pdf')
    plt.show()

if __name__ == '__main__':
    plot()
