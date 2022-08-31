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
5;
0,578.4310349,-0.0404817;
1,152.7792004,-20.6194344;
2,44.9301524,-116.7522279;
2,11.4587918,-43.7975806;
2,3.7523267,-5.4247609;
4;
0,59.4715114,2.9801339;
1,17.2173553,34.7834676;
2,18.4797093,28.8453246;
2,4.3276192,64.7642088;
4;
0,45.7271005,4.9885783;
1,49.4595886,19.6506564;
2,18.9952373,194.0943181;
2,3.6603193,43.1349769;
5;
0,62.8268435,3.0066647;
1,31.8897904,25.9879250;
2,18.3646572,85.7172897;
2,7.3062400,48.7792568;
2,2.4051635,11.4535104;
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
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save 
