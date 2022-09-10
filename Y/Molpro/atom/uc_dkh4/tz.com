***,Calculation for Y atom, singlet and triplet
memory,512,m

set,dkroll=1,dkho=10,dkhp=4

geometry={
1
Y
Y  0.0 0.0 0.0
}

basis={
include,aug-cc-pwCVTZ.basis
}



include,states.proc


do i=1,1
    if (i.eq.1) then
        Id1s2
    else if (i.eq.2) then
        Is2p1
    else if (i.eq.3) then
        EAd2s2
    else if (i.eq.4) then
        IIds2
    else if (i.eq.5) then
        IId1s1
    else if (i.eq.6) then
        IIId1s
    else if (i.eq.7) then
        IIIp1s
    else if (i.eq.8) then
        IIIsf1
    else if (i.eq.9) then
        IVd
    else if (i.eq.10) then
        Vp5
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
    {rccsd(t),maxit=100;core,5,2,2,1,2,1,1}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save

