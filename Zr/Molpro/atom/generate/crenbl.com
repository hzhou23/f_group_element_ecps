***,Calculation for Zr atom, singlet and triplet
memory,1,g
geometry={
1
Zr
Zr  0.0 0.0 0.0
}

gthresh,twoint=1.0E-15
gthresh,oneint=1.0E-15


basis={
ECP, zr, 28, 3 ;
5; !  ul potential
2,1.96560001,-0.27778301;
2,4.82639980,-6.66180706;
2,12.26459980,-38.94683075;
2,38.00030136,-86.41357422;
1,114.34359741,-20.21328354;
7; !  s-ul potential
2,2.70860004,51.15351486;
2,3.23639989,-166.17219543;
2,4.53420019,354.62121582;
2,6.97310019,-347.42883301;
2,10.91759968,262.91113281;
1,42.70869827,44.85594177;
0,158.05920410,2.81595111;
7; !  p-ul potential
2,2.57399988,53.14321518;
2,3.03749990,-172.25927734;
2,4.15030003,357.74844360;
2,6.21470022,-387.61001587;
2,9.40369987,275.60794067;
1,29.28240013,12.65426922;
0,25.48209953,5.28926516;
7; !  d-ul potential
2,1.78410006,35.59209442;
2,2.08969998,-115.19468689;
2,2.79329991,225.52505493;
2,4.06930017,-291.76715088;
2,5.94059992,232.36845398;
1,18.74440002,11.23965740;
0,16.13680077,7.27583790;
include,../generate/Zr-aug-cc-pwCVTZ.basis
}

include,../generate/Zr_states_ecp.proc

do i=1,15
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
    {rccsd(t),shifts=0.2,shiftp=0.2,thrdis=1.0;diis,1,1,15,1;maxit,100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
