#usr/bin/python3

import os
from script.Electron_configuration import *


name = 'Rh'
num_e = 45
core = [2,2,6,2,6,10]
ecp_states = [ [0,0,0,0,0,0,2,6,8,0,1], [0,0,0,0,0,0,2,6,8,0,0,1],[0,0,0,0,0,0,2,6,9], [0,0,0,0,0,0,2,6,8,0,2], [0,0,0,0,0,0,2,6,8], [0,0,0,0,0,0,2,6,7,0,1],[0,0,0,0,0,0,2,6,7], [0,0,0,0,0,0,2,6,6],[0,0,0,0,0,0,2,6,5,1],[0,0,0,0,0,0,2,6,5,0,0,1],[0,0,0,0,0,0,2,6,5],[0,0,0,0,0,0,2,6,4],[0,0,0,0,0,0,2,6,3],[0,0,0,0,0,0,2,6,2],[0,0,0,0,0,0,2,6,1],[0,0,0,0,0,0,2,6],[0,0,0,0,0,0,2,3]]

Rh = Electron_configure(name = name, num_e = num_e, core = core, ecp_states = ecp_states)
print(Rh.ae_configures)
print(Rh.ecp_configures)

work_path = os.getcwd()
result_path_ae = work_path+'/Rh/yoon_files/AE/'
ae_file_names = ["ae1.d","ae2.d","ae3.d","ae4.d","ae5.d","ae6.d","ae7.d","ae8.d","ae9.d","ae10.d","ae11.d","ae12.d","ae13.d","ae14.d", "ae15.d","ae16.d","ae17.d"]
Rh.write_yoon(result_path = result_path_ae, file_names = ae_file_names, ae = True)

result_path_ecp = work_path + '/Rh/yoon_files/ECP/'
ecp_file_names = ["ip1.d","ip2.d","ip3.d","ip4.d","ip5.d","ip6.d","ip7.d","ip8.d","ip9.d","ip10.d","ip11.d","ip12.d","ip13.d","ip14.d","ip15.d","ip16.d","ip17.d"]
Rh.write_yoon(result_path = result_path_ecp, file_names = ecp_file_names, ae = False)
#
molpro_path = './'
proc_names = [ "Id8s1", 'Id8p1','Id9','EAd8s2','IPd8','IPd7s1','IId7','IIId6','IIId5f1','IIId5p1','IVd5','Vd4','VId3','VIId2','VIIId1','IXp6','Xp3' ]
S_A =[ "4d", "5p", "4d", "4d", "4d", "4d", "4d", "4d", "4f", "5p", "4d", "4d","4d","4d","4d","4p","4p"]
Rh.write_Molpro(molpro_path = molpro_path, proc_name = proc_names, state_average_orbs = S_A, ae = True)

