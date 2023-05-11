***,Calculation for Lu atom, singlet and triplet
memory,1,g

gthresh,twoint=1.e-15
gthresh,oneint=1.e-15


geometry={
1
Lu
Lu  0.0 0.0 0.0
}

basis={
ECP, Lu, 60, 3 ;
4
1, 10.36455703983369,   11.0
3, 14.73570898426552,   114.010127438170590
2, 3.29123077521185 ,  -5.53386668217577
2, 1.55364493327677 ,  -4.75711181918621
2
2, 9.12544959004623 , 140.78068918317211
2, 2.02195561018770 ,  12.08139493965993
2
2, 8.44075047196737 ,  81.62179319733910
2, 2.05702647182184 ,  14.78862023166110
2
2, 3.79844841317851 ,  55.25133714672890
2, 3.18174638881567 ,  7.57669038547879
include,../generate/messyminus.basis
}



include,../generate/Lu60_states_ecp.proc

do i=1,17
    if (i.eq.1) then
        Id1s2
    else if (i.eq.2) then
        Ip1s2
    else if (i.eq.3) then
        IEd2s1
    else if (i.eq.4) then
        IEf1s2
    else if (i.eq.5) then
        IIds2
    else if (i.eq.6) then
        IId1s1
    else if (i.eq.7) then
        IIIds1
    else if (i.eq.8) then
        IIIp1
    else if (i.eq.9) then
        IIId1
    else if (i.eq.10) then
        IIIEf1
    else if (i.eq.11) then
        VIp6
    else if (i.eq.12) then
        VIIp5
    else if (i.eq.13) then
        VIIIp4
    else if (i.eq.14) then
        IXp3
    else if (i.eq.15) then
        Xp
    else if (i.eq.16) then
        XIds2
    else if (i.eq.17) then
        IIIEf2
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
