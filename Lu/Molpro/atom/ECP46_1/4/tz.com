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
ECP,Lu,46,4,0;
4 !ul
1,    4.526254,   25.000000
3,    3.879308,   113.15635
2,    4.406058,  -85.722649
2,    1.899664,   -3.133952
2 !s
2,    8.996757,  161.119164
2,    5.104371,   89.334835
2 !p
2,    7.640657,   88.693021
2,    3.878305,   57.109488
2 !d
2,    7.456305,   55.901690
2,    2.530445,   29.364333
2 !f
2,    4.939345,  -23.952530
2,    3.912490,   -7.090915
include,../aug-cc-pwCVTZ.basis
}



include,../Lu46_states_ecp.proc

do i=4,4
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
    {rccsd(t),shifts=1.5,shiftp=1.0,thrdis=1.0;diis,1,1,15,1;maxit,100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
