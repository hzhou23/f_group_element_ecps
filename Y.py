#usr/bin/python3

import os
from script.Electron_configuration import *


name = 'Y'
num_e = 39
core = [2,2,6,2,6,10]
ecp_states = [[0,0,0,0,0,0], [0,0,0,0,0,0,2,6,1,0,2], [0,0,0,0,0,0,2,6,0,0,2,1], [0,0,0,0,0,0,2,6,2,0,2], [0,0,0,0,0,0,2,6,0,0,2], [0,0,0,0,0,0,2,6,1,0,1], [0,0,0,0,0,0,2,6,1], [0,0,0,0,0,0,2,6,0,0,0,1],[0,0,0,0,0,0,2,6,0,1],[0,0,0,0,0,0,2,6],[0,0,0,0,0,0,2,5],[0,0,0,0,0,0,2,4],[0,0,0,0,0,0,2,3],[0,0,0,0,0,0,2,2],[0,0,0,0,0,0,2,1],[0,0,0,0,0,0,2]]

Y = Electron_configure(name = name, num_e = num_e, core = core, ecp_states = ecp_states)
#print(Y.ae_configures)
#print(Y.ecp_configures)

work_path = os.getcwd()
result_path_ae = work_path+'/Y/yoon_files/AE/'
ae_file_names = ["ae0.d","ae1.d","ae2.d","ae3.d","ae4.d","ae5.d","ae6.d","ae7.d","ae8.d","ae9.d","ae10.d","ae11.d","ae12.d","ae13.d","ae14.d", "ae15.d"]
Y.write_yoon(result_path = result_path_ae, file_names = ae_file_names, ae = True)

result_path_ecp = work_path + '/Y/yoon_files/ECP/'
ecp_file_names = ["ip0.d","ip1.d","ip2.d","ip3.d","ip4.d","ip5.d","ip6.d","ip7.d","ip8.d","ip9.d","ip10.d","ip11.d","ip12.d","ip13.d","ip14.d","ip15.d"]
Y.write_yoon(result_path = result_path_ecp, file_names = ecp_file_names, ae = False)

