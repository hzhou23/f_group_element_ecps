***,Calculation for Y atom, singlet and triplet
memory,1,g
geometry={
1
Y
Y  0.0 0.0 0.0
}

gthresh,twoint=1.0E-15
gthresh,oneint=1.0E-15


basis={
ECP, y, 28, 3 ;
4;
1,11.32216352394507,11.0
3,15.69582425055215,124.543798763395770
2,5.06791160426216,-20.04924398411820
2,4.44452608807987,-5.92948673415386
2;
2,6.86832537504466,154.15919867430935
2,3.83089977201277,18.38958965629789
2;
2,6.19374438133321,106.09583894990516
2,2.73929598061614,10.23789281785987
2;
2,5.30140448642357,48.14642857868520
2,2.23685208658110,7.59284283245229
include,aug-cc-pwCVTZ.basis
}

include,states.proc

do i=1,15
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
    {rccsd(t);maxit,100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
