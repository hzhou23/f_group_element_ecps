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
ECP, zr, 36, 3 ;
5; !  ul potential
2,0.50849998,-0.65333903;
2,1.25989997,-5.42695379;
2,3.85929990,-15.36555386;
2,12.27550030,-64.25210571;
1,38.51760101,-23.12731552;
7; !  s-ul potential
2,0.67790002,-60.99807739;
2,0.79229999,189.74023438;
2,1.04059994,-245.02844238;
2,1.44630003,219.89311218;
2,1.96200001,-110.71615601;
1,2.62660003,24.82860374;
0,10.83559990,3.39029098;
7; !  p-ul potential
2,0.78560001,139.57833862;
2,0.93400002,-287.81640625;
2,1.24940002,279.62557983;
2,1.77209997,-194.22854614;
2,2.47129989,104.41959381;
1,7.06279993,16.83250046;
0,8.15489960,5.69084311;
7; !  d-ul potential
2,0.09670000,0.00048200;
2,0.24150001,-0.17614000;
2,2.06349993,-43.04225159;
2,2.50259995,130.94032288;
2,3.20359993,-109.38676453;
1,5.27120018,13.35779476;
0,3.53810000,6.97829580;
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
