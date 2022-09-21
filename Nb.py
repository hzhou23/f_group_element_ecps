#usr/bin/python3

import os
from script.Electron_configuration import *


name = 'Nb'
num_e = 41
core = [2,2,6,2,6,10]
ecp_states = [ [0,0,0,0,0,0,2,6,4,0,1], [0,0,0,0,0,0,2,6,5], [0,0,0,0,0,0,2,6,4,1],[0,0,0,0,0,0,2,6,4,0,2], [0,0,0,0,0,0,2,6,4], [0,0,0,0,0,0,2,6,3,0,1], [0,0,0,0,0,0,2,6,3],[0,0,0,0,0,0,2,6,2],[0,0,0,0,0,0,2,6,1],[0,0,0,0,0,0,2,6,0,0,0,1],[0,0,0,0,0,0,2,6,0,1],[0,0,0,0,0,0,2,6],[0,0,0,0,0,0,2,5],[0,0,0,0,0,0,2,4],[0,0,0,0,0,0,2,3],[0,0,0,0,0,0,2,2],[0,0,0,0,0,0,2,1],[0,0,0,0,0,0,2]]

Nb = Electron_configure(name = name, num_e = num_e, core = core, ecp_states = ecp_states)
print(Nb.ae_configures)
print(Nb.ecp_configures)

work_path = os.getcwd()
result_path_ae = work_path+'/Nb/yoon_files/AE/'
ae_file_names = ["ae1.d","ae2.d","ae3.d","ae4.d","ae5.d","ae6.d","ae7.d","ae8.d","ae9.d","ae10.d","ae11.d","ae12.d","ae13.d","ae14.d", "ae15.d","ae16.d","ae17.d","ae18.d"]
Nb.write_yoon(result_path = result_path_ae, file_names = ae_file_names, ae = True)

result_path_ecp = work_path + '/Nb/yoon_files/ECP/'
ecp_file_names = ["ip1.d","ip2.d","ip3.d","ip4.d","ip5.d","ip6.d","ip7.d","ip8.d","ip9.d","ip10.d","ip11.d","ip12.d","ip13.d","ip14.d","ip15.d","ip16.d","ip17.d","ip18.d"]
Nb.write_yoon(result_path = result_path_ecp, file_names = ecp_file_names, ae = False)
#
molpro_path = './'
proc_names = [ "Id4s1", 'Id5','Id4f1','EAd4s2','IPd4','IPd3s1','IId3','IIId2','IVd1','IVp1','IVf1','Vp6','VIp5','VIIp4','VIIIp3','IXp2','Xp1','XIp' ]
S_A =[ "4d", "4d", "4d", "4d", "4d", "4d", "4d", "4d", "4d","5p", "4f", "4p", "4p", "4p", "4p","4p","4p","4s"]
Nb.write_Molpro(molpro_path = molpro_path, proc_name = proc_names, state_average_orbs = S_A, ae = False)
Nb.write_Molpro(molpro_path = molpro_path, proc_name = proc_names, state_average_orbs = S_A, ae = True)
