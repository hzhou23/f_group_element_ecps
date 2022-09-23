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


do i=7,7
    if (i.eq.1) then
        Id8s1
    else if (i.eq.2) then
        Id8p1
    else if (i.eq.3) then
        EAd8s2
    else if (i.eq.4) then
        IPd8
    else if (i.eq.5) then
        IIId5f1
    else if (i.eq.6) then
        VId3
    else if (i.eq.7) then
        Idf1
    endif
    scf(i)=energy
    !_CC_NORM_MAX=2.0
    !{rccsd(t),maxit=100;core}
    !ccsd(i)=energy
enddo

table,scf,!ccsd
type,csv
save

