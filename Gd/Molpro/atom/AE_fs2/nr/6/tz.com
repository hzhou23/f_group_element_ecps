***,Calculation for Gd atom, singlet and triplet
memory,1,g

gthresh,twoint=1.e-15
gthresh,oneint=1.e-15


geometry={
1
Gd
Gd  0.0 0.0 0.0
}

basis={
include,../aug-cc-pwCVTZ.basis
}



include,../Gd_states_ae.proc


do i=6,6
    if (i.eq.1) then
        Idf7s2
    else if (i.eq.2) then
        IIdf6s2
    else if (i.eq.3) then
        IIIdf5s2
    else if (i.eq.4) then
        IVdf4s2
    else if (i.eq.5) then
        Vdf3s2
    else if (i.eq.6) then
        VIdf2s2
    else if (i.eq.7) then
        VIIdf1s2
    else if (i.eq.8) then
        VIIIdfs2
    endif
    scf(i)=energy
    !_CC_NORM_MAX=2.0
    !{rccsd(t),maxit=100;core}
    !ccsd(i)=energy
enddo

table,scf,!ccsd
type,csv
save
