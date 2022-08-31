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
ECP, y, 28, 4 ;
1;
2,1.00000000,0.00000000;
2;
2,7.85827500,135.13497400;
2,3.38212800,15.41163200;
4;
2,6.84979100,29.25143700;
2,6.71009200,58.50836300;
2,3.04215900,3.78024300;
2,2.93733000,7.67654700;
4;
2,5.41631500,11.84991100;
2,5.33341600,17.77810300;
2,1.97621200,2.06238300;
2,1.96111100,3.07565400;
2;
2,5.02859000,-6.92807800;
2,5.00558200,-9.15509900;
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
    {rccsd(t),shifts=0.2,shiftp=0.2,thrdis=1.0;diis,1,1,15,1;maxit,100;core
    orbital,ignore_error}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save 
