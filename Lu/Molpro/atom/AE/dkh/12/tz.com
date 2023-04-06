***,Calculation for Gd atom, singlet and triplet
memory,2,g

gthresh,twoint=1.e-15
gthresh,oneint=1.e-15

set,dkroll=1,dkho=10,dkhp=4


geometry={
1
Lu
Lu  0.0 0.0 0.0
}

basis={
include,../aug-cc-pwCVTZ.basis
}



include,../Lu_states_ae.proc


do i=12,12
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
