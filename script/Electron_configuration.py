#usr/bin/python3

import numpy as np
import pandas as pd
import os
from typing import Dict, List, Tuple

class orbital_occupation:
    def __init__(self, occ_list: List[List[int]]) -> None:
        self.orbitals_names = ["1s", "2s", "2p", "3s", "3p", "3d", "4s", "4p", "4d", "4f", "5s", "5p" , "5d", "5f", "5g", "6s", "6p", "6d", "6f", "6g", "6h" , "7s", "7p", "7d"]
        self.occ_list = occ_list
        self.orbital_map={}
        for i in range(len(self.orbitals_names)):
            self.orbital_map[i] = self.orbitals_names[i]

    @property
    def state_occ(self) -> Dict[str, List]:
        state_name_occ = {}
        for occ_ele in self.occ_list:
            assert len(occ_ele) <= len(self.orbitals_names), "Occupation list too long, should not exceed {}".format(len(self.orbitals_names))
            state_name = []
            for i_num, i in enumerate(occ_ele):
                if i != 0:
                   state_name.append("{}{}".format(self.orbitals_names[i_num],i))

            state_name = " ".join(state_name)
            state_name_occ[state_name] = occ_ele

        return state_name_occ

    def __yoon_s(self, principal : int, n_e : int) -> str:
        return '{} 0 0 0 1 {}\n'.format(principal, n_e)

    def __yoon_p(self, principal : int, n_e : int) -> str:
        return '{} 1 -1 1 1 {}\n{} 1 0 1 1 {}\n{} 1 1 1 1 {}\n'.format(principal, min(max(n_e - 0, 0), 2), principal, min(max(n_e - 2, 0), 2), principal, min(max(n_e - 4, 0),2))

    def __yoon_d(self, principal : int, n_e : int) -> str :
        return '{} 2 -2 2 1 {}\n{} 2 -1 2 1 {}\n{} 2 0 2 1 {}\n{} 2 1 2 1 {}\n{} 2 2 2 1 {}\n'.format(principal, min(max(n_e - 0, 0), 2), principal, min(max(n_e - 2, 0), 2), principal, min(max(n_e - 4, 0),2), principal, min(max(n_e - 6, 0), 2), principal, min(max(n_e - 8, 0),2))

    def __yoon_f(self, principal : int, n_e : int) -> str :
        return '{} 3 -3 3 1 {}\n{} 3 -2 3 1 {}\n{} 3 -1 3 1 {}\n{} 3 0 3 1 {}\n{} 3 1 3 1 {}\n{} 3 2 3 1 {}\n{} 3 3 3 1 {}\n'.format(principal, min(max(n_e - 0, 0), 2), principal, min(max(n_e - 2, 0), 2), principal, min(max(n_e - 4, 0),2), principal, min(max(n_e - 6, 0), 2), principal, min(max(n_e - 8, 0),2), principal, min(max(n_e - 10, 0), 2), principal, min(max(n_e - 12, 0), 2))

    def yoon_state(self, state : List[int], ae : bool = True) -> Tuple[int,str]:
        yoon_content = []
        state_len = len(state)
        existing_orbital = []
        for key in self.orbital_map.keys():
            if key < state_len:
                existing_orbital.append(self.orbital_map[key])
        if ae:
            for orb_num,orb in enumerate(existing_orbital):
                orb_principal = int(orb[0])
                if orb[1] == 's':
                    yoon_orb = self.__yoon_s(principal = orb_principal, n_e = state[orb_num])
                elif orb[1] == 'p':
                    yoon_orb = self.__yoon_p(principal = orb_principal, n_e = state[orb_num])
                elif orb[1] == 'd':
                    yoon_orb = self.__yoon_d(principal = orb_principal, n_e = state[orb_num])
                else:
                    yoon_orb = self.__yoon_f(principal = orb_principal, n_e = state[orb_num])

                yoon_content.append(yoon_orb)
        else:
            non_zero_ind = next((i for i, x in enumerate(state) if x), None)
            if non_zero_ind is not None:
                non_zero_ele = self.orbital_map[non_zero_ind]
                ref_principal = int(non_zero_ele[0]) - 1
                existing_orbital = existing_orbital[non_zero_ind:]
                for orb_num,orb in enumerate(existing_orbital):
                    orb_principal = int(orb[0])
                    if orb[1] == 's':
                        yoon_orb = self.__yoon_s(principal = orb_principal-ref_principal, n_e = state[orb_num+non_zero_ind])
                    elif orb[1] == 'p':
                        yoon_orb = self.__yoon_p(principal = orb_principal-ref_principal+1, n_e = state[orb_num+non_zero_ind])
                    elif orb[1] == 'd':
                        yoon_orb = self.__yoon_d(principal = orb_principal-ref_principal+2, n_e = state[orb_num+non_zero_ind])
                    else:
                        yoon_orb = self.__yoon_f(principal = orb_principal-ref_principal+3, n_e = state[orb_num+non_zero_ind])
                
                    yoon_content.append(yoon_orb)
            else:
                yoon_content = []
        
        yoon_content = "".join(yoon_content)
        yoon_content_list = yoon_content.split('\n')
        yoon_content_list = [i for i in yoon_content_list if len(i)<1 or i[-1] != '0']
        yoon_content = '\n'.join(yoon_content_list)
        lines = yoon_content.count('\n')
        return lines,yoon_content

    def yoon(self, ae : bool = True) -> Tuple[List, List]:
        yoon_ae_contents = []
        yoon_ae_lines = []
        for state in self.occ_list:
            lines, content = self.yoon_state(state, ae)
            yoon_ae_lines.append(lines)
            yoon_ae_contents.append(content)
        
        return yoon_ae_lines, yoon_ae_contents

    def add_occ(occ_a: List[int], occ_b: List[int]) -> List[int]:
        max_len = max(len(occ_a), len(occ_b))
        while len(occ_a) <max_len:
            occ_a.append(0)
        while len(occ_b) <max_len:
            occ_b.append(0)
        final_occ = [occ_a[i]+occ_b[i] for i in range(max_len)]
        while final_occ[-1] == 0:
            final_occ.pop(-1)
        
        return final_occ


class Electron_configure:
    def __init__(self, name : str, num_e : int, core: List[int], ecp_states: List[List]) -> None:
        self.name = name
        self.num_e = num_e
        self.core = core
        self.ecp_states = ecp_states
        self.ae_states = []
        for ecp_ele in self.ecp_states:
            self.ae_states.append(orbital_occupation.add_occ(core, ecp_ele))
            while ecp_ele[-1] == 0 and len(ecp_ele) > 1:
                ecp_ele.pop(-1)

    @property
    def ae_configures(self) -> Dict[str, List]:
        ae_state_occ = orbital_occupation(occ_list = self.ae_states).state_occ
        return ae_state_occ
    
    @property
    def ecp_configures(self) -> Dict[str, List]:
        ecp_state_occ = orbital_occupation(occ_list = self.ecp_states).state_occ
        translate_key = {}
        for key,value in ecp_state_occ.items():
            translate_key[key] = "[{}]{}".format(sum(self.core), key)

        for old, new in translate_key.items():
             ecp_state_occ[new] = ecp_state_occ.pop(old)

        return ecp_state_occ
    
    def write_yoon(self, result_path: str, file_names: List[str], ae : bool = True) -> None:
        assert len(file_names) == len(self.ae_states), "Total number of files should equal to the length of AE states."
        os.makedirs(result_path, exist_ok = True)
        path_file_name = [result_path+i for i in file_names]
        if ae:
            occupation_line, occupation_table = orbital_occupation(occ_list = self.ae_states).yoon(ae = ae)
        else: 
            occupation_line, occupation_table = orbital_occupation(occ_list = self.ecp_states).yoon(ae = ae)

        for file_num, single_file in enumerate(path_file_name):
            with open(single_file, 'w') as f:
                if ae:
                    head = 'i\n{} 2000\nd\n0\nu\n2\na\n0 {} .5 .0001 100\n'.format(self.num_e, occupation_line[file_num])
                else:
                    head = 'i\n{} 2000\nd\n0\nu\n2\ng\na\n0 {} .5 .0001 200\n'.format(self.num_e, occupation_line[file_num])
                content = occupation_table[file_num]
                tail = 'w\nout\nq'
                combined_content = head+content+tail
                f.write(combined_content)




