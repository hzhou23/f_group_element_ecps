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
include,aug-cc-pwCVTZ.basis
}



include,Nb_states_ae.proc


do i=3,3
    if (i.eq.1) then
        IPd4
    else if (i.eq.2) then
        IId3
    else if (i.eq.3) then
        IVd1
    endif
    scf(i)=energy
    !_CC_NORM_MAX=2.0
    !{rccsd(t),maxit=100;core}
    !ccsd(i)=energy
enddo

table,scf,!ccsd
type,csv
save

