***,Calculation for Nb atom, singlet and triplet
memory,512,m

gthresh,twoint=1.e-15
gthresh,oneint=0.e-15

geometry={
1
Nb
Nb  0.0 0.0 0.0
}

basis={
include,aug-cc-pwCVTZ.basis
}

set,dkroll=1,dkho=10,dkhp=4

include,Nb_states_ae.proc


do i=1,18
    if (i.eq.1) then
        Id4s1
    else if (i.eq.2) then
        Id5
    else if (i.eq.3) then
        Id4f1
    else if (i.eq.4) then
        EAd4s2
    else if (i.eq.5) then
        IPd4
    else if (i.eq.6) then
        IPd3s1
    else if (i.eq.7) then
        IId3
    else if (i.eq.8) then
        IIId2
    else if (i.eq.9) then
        IVd1
    else if (i.eq.10) then
        IVp1
    else if (i.eq.11) then
        IVf1
    else if (i.eq.12) then
        Vp6
    else if (i.eq.13) then
        VIp5
    else if (i.eq.14) then
        VIIp4
    else if (i.eq.15) then
        VIIIp3
    else if (i.eq.16) then
        IXp2
    else if (i.eq.17) then
        Xp1
    else if (i.eq.18) then
        XIp

    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save

