***,Calculation for Nb atom, singlet and triplet
memory,512,m
geometry={
1
Nb
Nb  0.0 0.0 0.0
}

basis={
include,aug-cc-pwCVTZ.basis
}



include,Nb_states_ae.proc


do i=1,16
    if (i.eq.1) then
        Id4s1
    else if (i.eq.2) then
        IPd4
    else if (i.eq.3) then
        IPd4_1
    else if (i.eq.4) then
        IPd4_2
    else if (i.eq.5) then
        IPd4_3
    else if (i.eq.6) then
        IId3
    else if (i.eq.7) then
        IId3_1
    else if (i.eq.8) then
        IId3_2
    else if (i.eq.9) then
        IId3_3
    else if (i.eq.10) then
        IId3_4
    else if (i.eq.11) then
        IId3_5
    else if (i.eq.12) then
        IId3_6
    else if (i.eq.13) then
        IVd1
    else if (i.eq.14) then
        IVd1_1
    else if (i.eq.15) then
        IVd1_2
    else if (i.eq.16) then
        IVd1_3
    endif
    scf(i)=energy
    !_CC_NORM_MAX=2.0
    !{rccsd(t),maxit=100;core}
    !ccsd(i)=energy
enddo

table,scf,!ccsd
type,csv
save

