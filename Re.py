#usr/bin/python3

import os
from script.Electron_configuration import *


name = 'Re'
num_e = 75
core = [2,2,6,2,6,10,2,6,10,14]
ecp_states = [
[0]*10+[2,6,5,0,0,2],
[0]*10+[2,6,6,0,0,1],
[0]*10+[2,6,6,0,0,2],
[0]*10+[2,6,5,0,0,1],
[0]*10+[2,6,5,1],
[0]*10+[2,6,5,0,0,0,1],
[0]*10+[2,6,5],
[0]*10+[2,6,4],
[0]*10+[2,6,3],
[0]*10+[2,6,2],
[0]*10+[2,6,1],
[0]*10+[2,6,0,1],
[0]*10+[2,6,0,0,0,0,1],
[0]*10+[2,6],
[0]*10+[2,5],
[0]*10+[2,3],
        ]

Re = Electron_configure(name = name, num_e = num_e, core = core, ecp_states = ecp_states)
print(Re.ae_configures)
print(Re.ecp_configures)

work_path = os.getcwd()
result_path_ae = work_path+'/Re/yoon_files/AE/'
ae_file_names = ["ae1.d","ae2.d","ae3.d","ae4.d","ae5.d","ae6.d","ae7.d","ae8.d","ae9.d","ae10.d","ae11.d","ae12.d","ae13.d","ae14.d", "ae15.d","ae16.d"]
Re.write_yoon(result_path = result_path_ae, file_names = ae_file_names, ae = True)

result_path_ecp = work_path + '/Re/yoon_files/ECP/'
ecp_file_names = ["ip1.d","ip2.d","ip3.d","ip4.d","ip5.d","ip6.d","ip7.d","ip8.d","ip9.d","ip10.d","ip11.d","ip12.d","ip13.d","ip14.d","ip15.d","ip16.d"]
Re.write_yoon(result_path = result_path_ecp, file_names = ecp_file_names, ae = False)

molpro_path = './'
proc_names = [ "Id5s2", 'Id6s1','EAd6s2','IPd5s1','IPd5f1','IPd5p1','IId5','IIId4','IVd3','Vd2','VId1','VIf1','VIp1','VIIp6','VIIIp5','IXp3' ]
S_A =[ "5d", "5d", "5d", "5d", "5f", "6p", "5d", "5d", "5d", "5d", "5d", "5f","6p","5p","5p","5p"]
Re.write_Molpro(molpro_path = molpro_path, proc_name = proc_names, state_average_orbs = S_A, ae = False)
Re.write_Molpro(molpro_path = molpro_path, proc_name = proc_names, state_average_orbs = S_A, ae = True)
