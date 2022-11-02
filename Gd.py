#usr/bin/python3

import os
from script.Electron_configuration import *


name = 'Gd'
num_e = 64
core = [2,2,6,2,6,10,2,6,10]
ecp_states = [
[0]*9+[7,2,6,1,0,0,2],
[0]*9+[7,2,6,2,0,0,1],
[0]*9+[7,2,6,2,0,0,2],
[0]*9+[7,2,6,1,0,0,1],
[0]*9+[7,2,6,0,0,0,2],
[0]*9+[7,2,6,1],
[0]*9+[7,2,6],
[0]*9+[6,2,6],
[0]*9+[5,2,6],
[0]*9+[4,2,6],
[0]*9+[3,2,6],
[0]*9+[2,2,6],
[0]*9+[1,2,6],
[0]*9+[0,2,6],
[0]*9+[0,2,4],
[0]*9+[0,2,3],
        ]

Gd = Electron_configure(name = name, num_e = num_e, core = core, ecp_states = ecp_states)
print(Gd.ae_configures)
print(Gd.ecp_configures)

work_path = os.getcwd()
result_path_ae = work_path+'/Gd/yoon_files/AE/'
ae_file_names = ["ae1.d","ae2.d","ae3.d","ae4.d","ae5.d","ae6.d","ae7.d","ae8.d","ae9.d","ae10.d","ae11.d","ae12.d","ae13.d","ae14.d", "ae15.d","ae16.d"]
Gd.write_yoon(result_path = result_path_ae, file_names = ae_file_names, ae = True)

result_path_ecp = work_path + '/Gd/yoon_files/ECP/'
ecp_file_names = ["ip1.d","ip2.d","ip3.d","ip4.d","ip5.d","ip6.d","ip7.d","ip8.d","ip9.d","ip10.d","ip11.d","ip12.d","ip13.d","ip14.d","ip15.d","ip16.d"]
Gd.write_yoon(result_path = result_path_ecp, file_names = ecp_file_names, ae = False)

molpro_path = './'
proc_names = [ "Id1f7s2", 'Id2f7s1','EAd2f7s2','IId1f7s1','IIdf7s2','IIId1f7','IVdf7','Vdf6','VIdf5','VIIdf4','VIIIdf3','IXdf2','Xdf1','XIdf','XIIp4','XIIIp3' ]
S_A =[ "5d", "5d", "5d", "5d", "4f", "5d", "4f", "4f", "4f", "4f", "4f", "4f","4f","5p","5p","5p"]
Gd.write_Molpro(molpro_path = molpro_path, proc_name = proc_names, state_average_orbs = S_A, ae = False)
Gd.write_Molpro(molpro_path = molpro_path, proc_name = proc_names, state_average_orbs = S_A, ae = True)
