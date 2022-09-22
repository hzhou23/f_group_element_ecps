***,Calculation for Rh atom, singlet and triplet
memory,512,m
geometry={
1
Rh
Rh  0.0 0.0 0.0
}

basis={
include,aug-cc-pwCVTZ.basis
}



include,Rh_states_ae.proc


do i=1,17
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
        IIId5f1
    else if (i.eq.10) then
        IIId5p1
    else if (i.eq.11) then
        IVd5
    else if (i.eq.12) then
        Vd4
    else if (i.eq.13) then
        VId3
    else if (i.eq.14) then
        VIId2
    else if (i.eq.15) then
        VIIId1
    else if (i.eq.16) then
        IXp6
    else if (i.eq.17) then
        Xp3
    endif
    scf(i)=energy
    !_CC_NORM_MAX=2.0
    !{rccsd(t),maxit=100;core}
    !ccsd(i)=energy
enddo

table,scf,!ccsd
type,csv
save
