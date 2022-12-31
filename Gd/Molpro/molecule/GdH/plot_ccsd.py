#! /usr/bin/env python

import sys,os
import pandas as pd
import matplotlib.pyplot as plt


toev = 27.211386

ref = {'rccsdt':[108.948597100215, 11268.0176507189, 11270.5746273344] , 'rccsdT':[108.949703384635, 11268.018886104, 11270.5767078513] , 'RCCSDT':[108.948353465892,11268.0172922890,11270.5744293063] }

def plot_ccsdt(data_type):
    
    file_name = data_type+'.csv'
    data = pd.read_csv(file_name, delim_whitespace=True)

    r = data['r']
    ecp = data['ECP17']+ref[data_type][0]+0.49982987
    uc = data['UC']+ref[data_type][1]+0.49982785
    ae = data['AE']+ref[data_type][2]+0.49982785

    fig=plt.figure()
    ax = fig.add_subplot(111)
    plt.plot(r,ecp,color='b',label = 'ecp')
    plt.plot(r,uc,color='r',label = 'uc')
    plt.plot(r,ae,color='k',label = 'ae')
    
    plt.title(data_type)
    plt.legend()
    out_name=data_type+'.pdf'
    plt.savefig(out_name)


#~~~Analyze Binding Energy~~~~~

if __name__ == '__main__':

    plot_ccsdt('rccsdt')
    plot_ccsdt('rccsdT')
    plot_ccsdt('RCCSDT')

