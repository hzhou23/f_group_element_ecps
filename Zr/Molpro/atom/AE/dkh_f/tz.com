***,Calculation for Zr atom, singlet and triplet
memory,512,m

gthresh,twoint=1.e-15
gthresh,oneint=0.e-15


geometry={
1
Zr
Zr  0.0 0.0 0.0
}

basis={
include,aug-cc-pwCVTZ.basis
}

set,dkroll=1,dkho=10,dkhp=4

include,Zr_states_ae.proc

do i=9,9
    if (i.eq.1) then
        Id2s2
    else if (i.eq.2) then
        Id3s1
    else if (i.eq.3) then
        EAd3s2
    else if (i.eq.4) then
        IPd2s1
    else if (i.eq.5) then
        IPd3
    else if (i.eq.6) then
        IId2
    else if (i.eq.7) then
        IIId1
    else if (i.eq.8) then
        IIIp1
    else if (i.eq.9) then
        III_f1
    else if (i.eq.10) then
        IVp6
    else if (i.eq.11) then
        VIp4
    else if (i.eq.12) then
        VIIp3
    else if (i.eq.13) then
        VIIIp2
    else if (i.eq.14) then
        IXp1
    else if (i.eq.15) then
        Xp
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save

