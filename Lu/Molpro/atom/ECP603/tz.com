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
ECP, Lu, 60, 4 ;
4
1 19.80505380593775  11.0
3 9.82624404593776  217.855591865315250
2 5.00000000000000  -58.38448792450471
2 3.26294313541329  -0.07095903974103
2
2 6.99757180724091  200.08079886628161
2 4.20323929312433  -4.02649422905799
2
2 7.28361768771788  9.37572250044135
2 2.47403541592714  22.84214331173100
2
2 7.90262143684113  39.91731094729793
2 1.42550806182312  4.12064029714280
2
2 1.09238330282668  4.85101487807663
2 2.02216161122899  -12.51077360162869
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
    {rccsd(t),shifts=1.5,shiftp=1.0,thrdis=1.0;diis,1,1,15,1;maxit,100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
