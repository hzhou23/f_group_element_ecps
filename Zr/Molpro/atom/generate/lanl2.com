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
0,645.9321873,-0.0425843;
1,134.7547401,-20.2222409;
2,42.3074619,-101.8695172;
2,12.0003227,-41.6195784;
2,4.1260454,-4.6986160;
3; !  s-ul potential
0,117.6251862,2.7910559;
1,22.9646089,41.9489459;
2,4.5225298,67.7271866;
4; !  p-ul potential
0,47.1953145,4.9911144;
1,48.0356033,20.7193172;
2,19.4541456,195.5867758;
2,4.0512875,48.2877176;
5; !  d-ul potential
0,79.9073983,3.0049226;
1,45.8263798,25.9377989;
2,26.9903522,125.1244934;
2,9.6835718,70.7634022;
2,2.7995666,15.0492822;
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
