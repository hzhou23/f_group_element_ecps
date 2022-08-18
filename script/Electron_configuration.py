#usr/bin/python3

import numpy as np
import pandas as pd
import os
import ujson
from typing import Dict, List, Tuple
from itertools import combinations
from collections import Counter
from fractions import gcd
from functools import reduce

class orbital_sym():
    def __init__(self, name: str, half_fill : int, full_fill : int, symmetries: List[int])-> None:
        self.name = name
        self.half_fill = half_fill
        self.full_fill = full_fill
        self.symmetries = symmetries
    
class s(orbital_sym):
    
    def __init__(self)-> None:
        super().__init__( 's',1,2,[1])

class p(orbital_sym):

    def __init__(self)-> None:
        super().__init__('p',3,6,[2,3,5])

class d(orbital_sym):

    def __init__(self)-> None:
        super().__init__( 'd',5,10,[1,1,4,6,7])

class f(orbital_sym):

    def __init__(self)-> None:
        super().__init__( 'f',7,14,[2,2,3,3,5,5,8])


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
        base,extra = divmod(n_e, 3)
        n_e_sites = [base+(i<extra) for i in range(3)]
        return '{} 1 -1 1 1 {}\n{} 1 0 1 1 {}\n{} 1 1 1 1 {}\n'.format(principal, n_e_sites[0], principal, n_e_sites[1], principal, n_e_sites[2])

    def __yoon_d(self, principal : int, n_e : int) -> str :
        base,extra = divmod(n_e, 5)
        n_e_sites = [base+(i<extra) for i in range(5)]
        return '{} 2 -2 2 1 {}\n{} 2 -1 2 1 {}\n{} 2 0 2 1 {}\n{} 2 1 2 1 {}\n{} 2 2 2 1 {}\n'.format(principal, n_e_sites[0], principal, n_e_sites[1], principal, n_e_sites[2], principal, n_e_sites[3], principal, n_e_sites[4])

    def __yoon_f(self, principal : int, n_e : int) -> str :
        base,extra = divmod(n_e, 7)
        n_e_sites = [base+(i<extra) for i in range(7)]
        return '{} 3 -3 3 1 {}\n{} 3 -2 3 1 {}\n{} 3 -1 3 1 {}\n{} 3 0 3 1 {}\n{} 3 1 3 1 {}\n{} 3 2 3 1 {}\n{} 3 3 3 1 {}\n'.format(principal, n_e_sites[0], principal, n_e_sites[1], principal, n_e_sites[2], principal, n_e_sites[3], principal, n_e_sites[4], principal, n_e_sites[5], principal, n_e_sites[6])

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

    def molpro_rhf(self, proc_name : None, state_average_orbs : List[str]) -> List[str]:
        if proc_name == None:
            
            occ_list_rhf = []
            for i_num, i in enumerate(self.occ_list):
                state_weights, wf_triples = self.molpro_wf(i, state_average_orbs[i_num])
                wf_triple = wf_triples[0]
                molpro_occ_line, molpro_closed_line = self.molpro_occ_closed_line(i)

                tmp_rhf = '{{rhf,nitord=1,maxit=0\n start,5202.2\n wf,{}\n occ,{}\n closed,{}\n}}\nendproc\n\n\n'.format(wf_triple, molpro_occ_line, molpro_closed_line)
                occ_list_rhf.append(tmp_rhf)

        else:

            occ_list_rhf = []
            for i_num, i in enumerate(self.occ_list):
                state_weights, wf_triples = self.molpro_wf(i, state_average_orbs[i_num])
                wf_triple = wf_triples[0]
                molpro_occ_line, molpro_closed_line = self.molpro_occ_closed_line(i)

                tmp_rhf = 'proc {}\n{{rhf\n start,atden\n print,orbitals=2\n wf,{}\n occ,{}\n closed,{}\n orbital,4202.2\n}}'.format(proc_name[i_num], wf_triple, molpro_occ_line, molpro_closed_line)
                occ_list_rhf.append(tmp_rhf)

        return occ_list_rhf


    def molpro_multi(self, state_average_orbs : List[str]) -> List[str]:
        multi_list = []

        for i_num,i in enumerate(self.occ_list):
            pseudo_occ_state, pseudo_closed_state = self.molpro_pseudo(i, state_average_orb = state_average_orbs[i_num])
            pseudo_occ_line = self.molpro_occ_closed_line(pseudo_occ_state)[0]
            pseudo_closed_line = self.molpro_occ_closed_line(pseudo_closed_state)[1]
            state_weights,wf_triples = self.molpro_wf(i, state_average_orb = state_average_orbs[i_num])
            multi_content = '\npop\n{{multi\n start,4202.2\n occ,{}\n closed,{}\n'.format(pseudo_occ_line, pseudo_closed_line)
            for i_num in range(len(wf_triples)):
                multi_content += ' wf,{};state,{}\n'.format(wf_triples[i_num],state_weights[i_num])
            multi_content += ' orbital,5202.2\n}\n'
            
            multi_list.append(multi_content)

        return multi_list



    def molpro_wf(self, state : List[int], state_average_orb: str) -> Tuple[List[int],List[str]]: 
        ''' For a given input state, and the given state average orbital, it will return : number of valence electron, total symmetry and number of open shell electron as a list.'''
        
        weights=[]
        molpro_wf_list=[]
        for k,v in self.orbital_map.items():
            if v == state_average_orb:
                num_e = state[k]
        
        if state_average_orb[1] == 's':
            orb_feature = s()
        elif state_average_orb[1] == 'p':
            orb_feature = p()
        elif state_average_orb[1] == 'd':
            orb_feature = d()
        elif state_average_orb[1] == 'f':
            orb_feature = f()

        site=list(range(len(orb_feature.symmetries)))
        if num_e <= orb_feature.half_fill:
            open_shell = num_e
        else:
            open_shell = orb_feature.full_fill - num_e

        index_list = list(combinations(site, num_e))
        if len(index_list) == 0:
            index_list = [(0,0)]
        symmetry = []
        for ind in index_list :
            tmp_sym = [orb_feature.symmetries[i] for i in ind]
            symmetry.append(total_sym(tmp_sym))
        
        sym_counter = Counter(symmetry)
        for k,v in sym_counter.items():
            wf = [0,0,0]
            wf[0] = sum(state)
            wf[1] = int(k)
            wf[2] = open_shell
            weights.append(v)
            wf = ','.join(map(str, wf))
            molpro_wf_list.append(wf)
        
        weights_gcd = reduce(gcd, weights)
        state_weights = [int(i/weights_gcd) for i in weights]
        return state_weights,molpro_wf_list

    

    def molpro_occ_closed_line(self, state:List[int])->Tuple[str,str]:
        occ_line = [0]*8
        closed = [0]*8
        for i_num, i in enumerate(state):
            orb = self.orbital_map[i_num][1]
            tmp_occ_line,tmp_closed = self.molpro_single_orb_sym_occ_closed(orb=orb, occ = i)
            occ_line = [occ_line[i] + tmp_occ_line[i] for i in range(8)]
            closed = [closed[i] + tmp_closed[i] for i in range(8)]
        occ_line=','.join(map(str, occ_line))
        closed = ','.join(map(str, closed))
        return occ_line, closed

    

    

    def molpro_pseudo(self, state: List[int], state_average_orb : str) -> Tuple[List[int], List[int]]:
        
        pseudo_occ_state=ujson.loads(ujson.dumps(state))
        pseudo_closed_state=ujson.loads(ujson.dumps(state))
        
        for k,v in self.orbital_map.items():
            if v == state_average_orb:
                pseudo_closed_state[k] = 0
                if v[1] == 's':
                    pseudo_occ_state[k] = 2
                elif v[1] == 'p':
                    pseudo_occ_state[k] = 6
                elif v[1] == 'd':
                    pseudo_occ_state[k] = 10
                elif v[1] == 'f':
                    pseudo_occ_state[k] = 14
                else:
                    raise Exception("Only s, p, d, f orbitals supported in state average calculations.")
                    
        return pseudo_occ_state, pseudo_closed_state

    def molpro_single_orb_sym_occ_closed(self, orb : str, occ: int) ->Tuple[ List[int], List[int]]:
        sym_occ_list = [0]*8
        sym_closed_list = [0]*8
        if orb == 's':
            orb_f = s()
            occ_list = [0]
            closed_list = [0]
            occ_list[0] = occ
            for i_num,i in enumerate(occ_list):
                if i != 0:
                    sym_occ_list[orb_f.symmetries[i_num]-1] += 1
                if i == 2:
                    sym_closed_list[orb_f.symmetries[i_num]-1] += 1

        elif orb == 'p':
            orb_f = p()
            base,extra = divmod(occ, 3)
            occ_list = [base+(i<extra) for i in range(3)]
            for i_num,i in enumerate(occ_list):

                if i != 0:
                    sym_occ_list[orb_f.symmetries[i_num]-1] += 1
                if i == 2:
                    sym_closed_list[orb_f.symmetries[i_num]-1] += 1

        elif orb =='d' :
            orb_f = d()
            base,extra = divmod(occ, 5)
            occ_list = [base+(i<extra) for i in range(5)]
            for i_num,i in enumerate(occ_list):
                if i != 0:
                    sym_occ_list[orb_f.symmetries[i_num]-1] += 1
                if i == 2:
                    sym_closed_list[orb_f.symmetries[i_num]-1] += 1

        elif orb =='f' :
            orb_f = f()
            base,extra = divmod(occ, 7)
            occ_list = [base+(i<extra) for i in range(7)]
            for i_num,i in enumerate(occ_list):
                if i != 0:
                    sym_occ_list[orb_f.symmetries[i_num]-1] += 1
                if i == 2:
                    sym_closed_list[orb_f.symmetries[i_num]-1] += 1
        
        return sym_occ_list,sym_closed_list

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

    def write_Molpro(self, molpro_path : str , proc_name: List[str], state_average_orbs: List[str] ,ae = True) -> None:
        assert len(proc_name) == len(self.ae_states), "Total number of states in states.proc should be the same of the number of given states."
        print("Writing Molpro files...\n NOTE: In the states.proc file, no 'sym' or 'restrict' were added, please make sure you add them later on.")
        os.makedirs(molpro_path, exist_ok = True)
        if ae:
            statesproc = molpro_path + '/states_ae_nosym.proc'
            first_rhf = orbital_occupation(occ_list = self.ae_states).molpro_rhf(proc_name = proc_name, state_average_orbs = state_average_orbs)
            multi = orbital_occupation(occ_list = self.ae_states).molpro_multi(state_average_orbs = state_average_orbs)
            last_rhf = orbital_occupation(occ_list = self.ae_states).molpro_rhf(proc_name = None,state_average_orbs = state_average_orbs)
        else :
            statesproc = molpro_path + '/states_ecp_nosym.proc'
            first_rhf = orbital_occupation(occ_list = self.ecp_states).molpro_rhf(proc_name = proc_name, state_average_orbs = state_average_orbs)
            multi = orbital_occupation(occ_list = self.ecp_states).molpro_multi(state_average_orbs = state_average_orbs)
            last_rhf = orbital_occupation(occ_list = self.ecp_states).molpro_rhf(proc_name = None,state_average_orbs = state_average_orbs)
        
        final_content = ""
        for i_num in range(len(first_rhf)):
            final_content += first_rhf[i_num]+multi[i_num]+last_rhf[i_num]
        
        with open(statesproc, 'w') as f:
            f.write(final_content)


def bipart_sym(sym_1 : int, sym_2 : int) -> int:
    sym_dict = {(1,1): 1, (1,2):2, (1,3): 3, (1,4):4, (1,5):5, (1,6):6, (1,7):7, (1,8):8,
            (2,2):1, (2,3):4, (2,4):3, (2,5):6, (2,6):5, (2,7):8, (2,8):7,
            (3,3):1, (3,4):2, (3,5):7, (3,6):8, (3,7):5, (3,8):6,
            (4,4):1, (4,5):8, (4,6):7, (4,7):6, (4,8):5,
            (5,5):1, (5,6):2, (5,7):3, (5,8):4,
            (6,6):1, (6,7):4, (6,8):3,
            (7,7):1, (7,8):2,
            (8,8):1}

    for k,v in sym_dict.items():
        if sym_1 <= sym_2:
            if sym_1 == k[0] and sym_2 == k[1]:
                return v
        else :
            if sym_2 == k[0] and sym_1 == k[1]:
                return v


def total_sym(sym_list: List[int])-> int:
    assert len(sym_list) >= 1, "symmetry list cannot be smaller than 1."

    current_sym = 1 
    for i_num in range(len(sym_list)):
        current_sym = bipart_sym(current_sym, sym_list[i_num])

    return current_sym


