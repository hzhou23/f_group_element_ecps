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
2; 2,9.376578,165.156736; 2,4.043572,21.823951; 
4; 2,8.363609,37.249284; 2,8.166898,74.507389; 2,3.693075,5.439486; 2,3.551047,10.913252; 
4; 2,6.689108,15.214549; 2,6.537193,22.833508; 2,2.551118,3.000052; 2,2.567896,4.553734; 
2; 2,5.568285,-6.281354; 2,5.671372,-8.755644; 
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
    {rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
