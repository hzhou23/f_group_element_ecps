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
ECP, nb, 28, 3 ;
5; !  ul potential
0,342.9638405,-0.0447401;
1,139.9308014,-20.0535100;
2,43.3523405,-103.7244021;
2,12.4448533,-41.0459165;
2,4.3204837,-4.2046219;
3; !  s-ul potential
0,112.8630617,2.7964669;
1,22.9678676,42.8845786;
2,4.9340673,75.1876966;
4; !  p-ul potential
0,63.6801963,4.9461846;
1,23.0912429,24.8316376;
2,24.4283647,137.9183292;
2,4.2310090,50.9778471;
5; !  d-ul potential
0,99.3359636,3.0064059;
1,64.0586472,25.5347458;
2,37.0891011,178.9597452;
2,12.0708574,92.9577490;
2,3.1575323,18.4744256;
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
