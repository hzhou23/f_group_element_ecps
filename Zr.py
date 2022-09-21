#usr/bin/python3

import os
from script.Electron_configuration import *


name = 'Zr'
num_e = 40
core = [2,2,6,2,6,10]
ecp_states = [ [0,0,0,0,0,0,2,6,2,0,2], [0,0,0,0,0,0,2,6,3,0,1],[0,0,0,0,0,0,2,6,3,0,0,1], [0,0,0,0,0,0,2,6,3,0,2], [0,0,0,0,0,0,2,6,2,0,1], [0,0,0,0,0,0,2,6,3], [0,0,0,0,0,0,2,6,2], [0,0,0,0,0,0,2,6,1],[0,0,0,0,0,0,2,6,0,0,0,1],[0,0,0,0,0,0,2,6,0,1],[0,0,0,0,0,0,2,6],[0,0,0,0,0,0,2,5],[0,0,0,0,0,0,2,4],[0,0,0,0,0,0,2,3],[0,0,0,0,0,0,2,2],[0,0,0,0,0,0,2,1],[0,0,0,0,0,0,2]]

Zr = Electron_configure(name = name, num_e = num_e, core = core, ecp_states = ecp_states)
print(Zr.ae_configures)
print(Zr.ecp_configures)

work_path = os.getcwd()
result_path_ae = work_path+'/Zr/yoon_files/AE/'
ae_file_names = ["ae1.d","ae2.d","ae3.d","ae4.d","ae5.d","ae6.d","ae7.d","ae8.d","ae9.d","ae10.d","ae11.d","ae12.d","ae13.d","ae14.d", "ae15.d","ae16.d","ae17.d"]
Zr.write_yoon(result_path = result_path_ae, file_names = ae_file_names, ae = True)

result_path_ecp = work_path + '/Zr/yoon_files/ECP/'
ecp_file_names = ["ip1.d","ip2.d","ip3.d","ip4.d","ip5.d","ip6.d","ip7.d","ip8.d","ip9.d","ip10.d","ip11.d","ip12.d","ip13.d","ip14.d","ip15.d","ip16.d","ip17.d"]
Zr.write_yoon(result_path = result_path_ecp, file_names = ecp_file_names, ae = False)

molpro_path = './'
proc_names = [ "Id2s2", 'Id3s1','Id3p1','EAd3s2','IPd2s1','IPd3','IId2','IIId1','IIIp1','IIIf1','IVp6','Vp5','VIp4','VIIp3','VIIIp2','IXp1','Xp' ]
S_A =[ "4d", "4d", "4d", "4d", "4d", "4d","4d", "4d","5p", "4f", "4p", "4p", "4p", "4p","4p","4p","4s"]
Zr.write_Molpro(molpro_path = molpro_path, proc_name = proc_names, state_average_orbs = S_A, ae = False)
Zr.write_Molpro(molpro_path = molpro_path, proc_name = proc_names, state_average_orbs = S_A, ae = True)
