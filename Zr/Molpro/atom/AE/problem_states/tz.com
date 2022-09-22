***,Calculation for Zr atom, singlet and triplet
memory,512,m
geometry={
1
Zr
Zr  0.0 0.0 0.0
}

basis={
include,aug-cc-pwCVTZ.basis
}



include,Zr_states_ae.proc


do i=1,2
    if (i.eq.1) then
        Id2s2
    else if (i.eq.2) then
        Vp5
    endif
    scf(i)=energy
    !_CC_NORM_MAX=2.0
    !{rccsd(t),maxit=100;core}
    !ccsd(i)=energy
enddo

table,scf,!ccsd
type,csv
save

