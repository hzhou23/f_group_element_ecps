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
include,../generate/Rh-aug-cc-pwCVTZ.basis
}

include,../generate/Rh_states_ecp.proc

do i=1,16
    if (i.eq.1) then
        Id8s1
    else if (i.eq.2) then
        Id8p1
    else if (i.eq.3) then
        Id9
    else if (i.eq.4) then
        EAd8s2
    else if (i.eq.5) then
        IPd8
    else if (i.eq.6) then
        IPd7s1
    else if (i.eq.7) then
        IId7
    else if (i.eq.8) then
        IIId6
    else if (i.eq.9) then
        IIId5p1
    else if (i.eq.10) then
        IVd5
    else if (i.eq.11) then
        Vd4
    else if (i.eq.12) then
        VId3
    else if (i.eq.13) then
        VIId2
    else if (i.eq.14) then
        VIIId1
    else if (i.eq.15) then
        IXp6
    else if (i.eq.16) then
        Xp3
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),shifts=0.2,shiftp=0.2,thrdis=1.0;diis,1,1,15,1;maxit,100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
