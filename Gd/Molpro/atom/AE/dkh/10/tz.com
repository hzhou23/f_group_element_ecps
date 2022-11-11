***,Calculation for Gd atom, singlet and triplet
memory,2,g


gthresh,twoint=1.e-15
gthresh,oneint=1.e-15

set,dkroll=1,dkho=10,dkhp=4

geometry={
1
Gd
Gd  0.0 0.0 0.0
}

basis={
include,../aug-cc-pwCVTZ.basis
}



include,../Gd_states_ae.proc


do i=10,10
    if (i.eq.1) then
        Id1f7s2
    else if (i.eq.2) then
        Id2f7s1
    else if (i.eq.3) then
        EAd2f7s2
    else if (i.eq.4) then
        IId1f7s1
    else if (i.eq.5) then
        IIdf7s2
    else if (i.eq.6) then
        IIId1f7
    else if (i.eq.7) then
        IVdf7
    else if (i.eq.8) then
        Vdf6
    else if (i.eq.9) then
        VIdf5
    else if (i.eq.10) then
        VIIdf4
    else if (i.eq.11) then
        VIIIdf3
    else if (i.eq.12) then
        IXdf2
    else if (i.eq.13) then
        Xdf1
    else if (i.eq.14) then
        XIdf
    else if (i.eq.15) then
        XIIp4
    else if (i.eq.16) then
        XIIIp3
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
