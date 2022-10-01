***,Calculation for Nb atom, singlet and triplet
memory,1,g
geometry={
1
Nb
Nb  0.0 0.0 0.0
}

gthresh,twoint=1.0E-15
gthresh,oneint=1.0E-15


basis={
ECP,Nb,28,4,0;
1; 2,1.000000,0.000000; 
2; 2,8.900000,165.179143; 2,4.430000,21.992974; 
2; 2,7.770000,111.794414; 2,3.960000,16.633483; 
2; 2,6.050000,38.112249; 2,2.840000,8.039167; 
2; 2,8.490000,-22.929550; 2,4.250000,-3.666310; 
include,../generate/Nb-aug-cc-pwCVTZ.basis
}

include,../generate/Nb_states_ecp.proc

do i=1,17
    if (i.eq.1) then
        Id4s1
    else if (i.eq.2) then
        Id5
    else if (i.eq.3) then
        EAd4s2
    else if (i.eq.4) then
        IPd4
    else if (i.eq.5) then
        IPd3s1
    else if (i.eq.6) then
        IId3
    else if (i.eq.7) then
        IIId2
    else if (i.eq.8) then
        IVd1
    else if (i.eq.9) then
        IVp1
    else if (i.eq.10) then
        IVf1
    else if (i.eq.11) then
        Vp6
    else if (i.eq.12) then
        VIp5
    else if (i.eq.13) then
        VIIp4
    else if (i.eq.14) then
        VIIIp3
    else if (i.eq.15) then
        IXp2
    else if (i.eq.16) then
        Xp1
    else if (i.eq.17) then
        XIp
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),shifts=0.2,shiftp=0.2,thrdis=1.0;diis,1,1,15,1;maxit,100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
