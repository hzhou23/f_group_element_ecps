***,Calculation for Rh atom, singlet and triplet
memory,1,g
geometry={
1
Rh
Rh  0.0 0.0 0.0
}

gthresh,twoint=1.0E-15
gthresh,oneint=1.0E-15


basis={
ECP,Rh,28,4,0;
1; 2,1.000000,0.000000; 
2; 2,11.720000,225.347754; 2,5.820000,32.823189; 
2; 2,10.420000,158.709412; 2,5.450000,26.444100; 
2; 2,8.820000,62.758626; 2,3.870000,10.978719; 
2; 2,12.310000,-30.093456; 2,6.160000,-5.218482; 
include,Rh-aug-cc-pwCVTZ.basis
}

include,Rh_ecp_states.proc

do i=1,15
    if (i.eq.1) then
        Id1s2
    else if (i.eq.2) then
        Is2p1
    else if (i.eq.3) then
        EAd2s2
    else if (i.eq.4) then
        IIds2
    else if (i.eq.5) then
        IId1s1
    else if (i.eq.6) then
        IIId1s
    else if (i.eq.7) then
        IIIp1s
    else if (i.eq.8) then
        IIIsf1
    else if (i.eq.9) then
        IVd
    else if (i.eq.10) then
        Vp5
    else if (i.eq.11) then
        VIp4
    else if (i.eq.12) then
        VIIp3
    else if (i.eq.13) then
        VIIIp2
    else if (i.eq.14) then
        IXp1
    else if (i.eq.15) then
        Xp
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),shifts=0.2,shiftp=0.2,thrdis=1.0;diis,1,1,15,1;maxit,100;core
    orbital,ignore_error}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
