***,Calculation for Nb atom, singlet and triplet
memory,1,g
geometry={
1
Nb
Nb  0.0 0.0 0.0
}

gthresh,twoint=1.0E-15
gthresh,oneint=1.0E-15


basis={
ECP, nb, 36, 3 ;
5; !  ul potential
2,0.65390003,-1.18631494;
2,1.74010003,-7.80844688;
2,6.60360003,-31.78058052;
2,22.66510010,-104.86203003;
1,86.96939850,-27.51132584;
7; !  s-ul potential
2,0.73820001,-62.14817429;
2,0.85650003,190.85089111;
2,1.11399996,-243.21609497;
2,1.53129995,221.00381470;
2,2.06570005,-114.93121338;
1,2.50189996,28.06257629;
0,10.75329971,3.42669392;
7; !  p-ul potential
2,0.88760000,151.04595947;
2,1.06459999,-307.14862061;
2,1.44579995,293.11035156;
2,2.08999991,-199.33251953;
2,2.99850011,112.10955811;
1,8.67920017,16.48614311;
0,8.90999985,5.68367910;
7; !  d-ul potential
2,0.64829999,0.23683000;
2,0.28490001,-0.23673899;
2,1.36430001,21.64477730;
2,1.46120000,-54.17031479;
2,1.66880000,41.12133026;
1,7.64370012,11.94430923;
0,6.68480015,7.14471006;
include,../generate/Nb-aug-cc-pwCVTZ.basis
}

include,../generate/Nb_states_ecp.proc

do i=1,17
    if (i.eq.1) then
        Id4s1
    else if (i.eq.2) then
        Id5
    else if (i.eq.3) then
        EAd4s2
    else if (i.eq.4) then
        IPd4
    else if (i.eq.5) then
        IPd3s1
    else if (i.eq.6) then
        IId3
    else if (i.eq.7) then
        IIId2
    else if (i.eq.8) then
        IVd1
    else if (i.eq.9) then
        IVp1
    else if (i.eq.10) then
        IVf1
    else if (i.eq.11) then
        Vp6
    else if (i.eq.12) then
        VIp5
    else if (i.eq.13) then
        VIIp4
    else if (i.eq.14) then
        VIIIp3
    else if (i.eq.15) then
        IXp2
    else if (i.eq.16) then
        Xp1
    else if (i.eq.17) then
        XIp
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
