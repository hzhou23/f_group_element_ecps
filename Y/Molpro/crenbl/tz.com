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
2,2.90050006,-2.22248793;
2,7.94630003,-23.57674599;
2,21.59399986,-59.28044128;
2,78.34619904,-164.74046326;
1,265.06298828,-22.87406540;
7;
2,2.68510008,55.64851379;
2,3.13739991,-177.82318115;
2,4.20650005,354.56311035;
2,6.10620022,-340.00125122;
2,8.79300022,239.03950500;
1,26.35610008,14.65989113;
0,26.61560059,3.39070010;
7;
2,2.37949991,50.28510666;
2,2.77360010,-160.27282715;
2,3.70539999,317.67678833;
2,5.37099981,-336.20748901;
2,7.78319979,237.31672668;
1,22.16099930,12.75121307;
0,20.47360039,5.37008190;
7;
2,1.58969998,33.29671097;
2,1.85490000,-109.96274567;
2,2.44250011,213.90904236;
2,3.47909999,-273.61801147;
2,4.95599985,207.30749512;
1,15.23060036,10.78762054;
0,13.37300015,7.32198191;
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
