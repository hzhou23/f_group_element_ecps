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
ECP, Lu, 46, 4 ;
4
1,  4.482334567,  25
3,  4.564889708,  112.058364175
2,  5.66712002 , -92.94902558036668
2,  3.16146066 , -4.588504296630954
2
2,  11.95874295,  158.70657318789057
2,  4.57502029 , 75.28362826274655
2
2,  9.32702741 , 85.29970272818532
2,  3.72730927 , 55.148895643005105
2
2,  9.14239802 , 55.31511392504553
2,  2.41026285 , 27.587515239861645
2
2,  3.49609108 , -24.9529154751256
2,  6.1622991  ,-2.920504453945625
include,../generate/aug-cc-pwCVTZ.basis
}



include,../generate/Lu46_states_ecp.proc

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
