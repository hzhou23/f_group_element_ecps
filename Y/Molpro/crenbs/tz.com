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
ECP, y, 36, 3 ;
6;
2,0.40310001,-0.38814399;
2,0.95459998,-3.85477591;
2,2.47849989,-9.36550999;
2,7.70930004,-39.12420654;
2,23.46579933,-93.54985046;
1,73.73259735,-25.21870422;
7;
2,0.52429998,-27.56872368;
2,0.61140001,80.27277374;
2,0.80330002,-101.27806091;
2,0.99680001,67.88915253;
2,3.88000011,37.90885544;
1,8.83150005,34.85948563;
0,22.29000092,3.96560407;
7;
2,0.68919998,127.96752930;
2,0.81430000,-265.12304688;
2,1.08150005,258.52642822;
2,1.51940000,-181.08963013;
2,2.09270000,94.94129181;
1,6.04059982,16.67901993;
0,7.35090017,5.70845318;
7;
2,0.23090000,-0.18540600;
2,1.29820001,22.32200432;
2,1.51409996,-70.94950867;
2,1.99890006,131.66903687;
2,2.56730008,-108.04507446;
1,4.38630009,11.55035400;
0,1.97099996,7.16109085;
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
