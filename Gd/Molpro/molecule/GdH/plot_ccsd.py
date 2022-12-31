#! /usr/bin/env python

import sys,os
import pandas as pd
import matplotlib.pyplot as plt


toev = 27.211386

def plot_ccsdt(data_type):
    file_name = data_type+'.csv'
    data = pd.read_csv(file_name, delim_whitespace=True)

    r = data['r']
    ecp = data['ECP17']+108.9485971+0.49982987
    uc = data['UC']+11268.01765+0.49982785
    ae = data['AE']+11270.57462733+0.49982785

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

