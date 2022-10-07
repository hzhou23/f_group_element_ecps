***,Calculation for Nb atom, singlet and triplet
memory,1,g

gthresh,twoint=1.e-15
gthresh,oneint=1.e-15


geometry={
1
Ta
Ta  0.0 0.0 0.0
}

basis={
include,../aug-cc-pwCVTZ.basis
}



include,../Ta_states_ae.proc


do i=8,8
    if (i.eq.1) then
        Id3s2
    else if (i.eq.2) then
        Id4s1
    else if (i.eq.3) then
        Id4p1
    else if (i.eq.4) then
        Id4f1
    else if (i.eq.5) then
        EAd5s1
    else if (i.eq.6) then
        IPd4
    else if (i.eq.7) then
        IPd3s1
    else if (i.eq.8) then
        IId3
    else if (i.eq.9) then
        IIId2
    else if (i.eq.10) then
        IVd1
    else if (i.eq.11) then
        IVf1
    else if (i.eq.12) then
        IVs1
    else if (i.eq.13) then
        IVp1
    else if (i.eq.14) then
        Vp6
    else if (i.eq.15) then
        VIp5
    else if (i.eq.16) then
        VIIp4
    else if (i.eq.17) then
        VIIIp3
    endif
    scf(i)=energy
    !_CC_NORM_MAX=2.0
    !{rccsd(t),maxit=100;core}
    !ccsd(i)=energy
enddo

table,scf,!ccsd
type,csv
save
