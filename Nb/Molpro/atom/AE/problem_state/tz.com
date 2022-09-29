***,Calculation for Nb atom, singlet and triplet

gthresh,twoint=1.e-15
gthresh,oneint=0.e-15

memory,512,m
geometry={
1
Nb
Nb  0.0 0.0 0.0
}

basis={
include,../nr/aug-cc-pwCVTZ.basis
}



include,Nb_states_ae.proc


do i=5,6
    if (i.eq.1) then
        Id4s1
    else if (i.eq.2) then
        IPd4
    else if (i.eq.3) then
        IId3
    else if (i.eq.4) then
        IVd1
    else if (i.eq.5) then
        EAd4s2
    else if (i.eq.6) then
        IVp1
    endif
    scf(i)=energy
    !_CC_NORM_MAX=2.0
    !{rccsd(t),maxit=100;core}
    !ccsd(i)=energy
enddo

table,scf,!ccsd
type,csv
save

