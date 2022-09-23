***,Calculation for Rh atom, singlet and triplet
memory,1,g
geometry={
1
Rh
Rh  0.0 0.0 0.0
}

gthresh,twoint=1.0E-15
gthresh,oneint=1.0E-15


basis={
ECP, rh, 28, 3 ;
5; !  ul potential
2,5.26849985,-3.34650707;
2,14.52709961,-36.27990723;
2,39.89099884,-79.27825165;
2,135.15080261,-219.38746643;
1,451.73019409,-24.89464378;
7; !  s-ul potential
2,2.33960009,-26.99048614;
2,2.77189994,88.46970367;
2,3.75909996,-175.11592102;
2,5.70620012,340.60363770;
2,8.72089958,-223.21163940;
1,13.09829998,47.58080292;
0,91.69550323,2.79638195;
7; !  p-ul potential
2,2.27749991,-22.92908096;
2,2.70799994,84.58609009;
2,3.56419992,-171.19743347;
2,5.25099993,316.75189209;
2,7.78830004,-225.04205322;
1,11.98419952,49.74481964;
0,70.47000122,4.39694500;
7; !  d-ul potential
2,2.72009993,40.01486969;
2,3.25489998,-131.79638672;
2,4.54110003,277.17028809;
2,6.98999977,-353.21633911;
2,11.21280003,332.40838623;
1,36.28559875,13.58090496;
0,30.69669914,7.15987301;
include,../generate/Rh-aug-cc-pwCVTZ.basis
}

include,../generate/Rh_states_ecp.proc

do i=1,16
    if (i.eq.1) then
        Id8s1
    else if (i.eq.2) then
        Id8p1
    else if (i.eq.3) then
        Id9
    else if (i.eq.4) then
        EAd8s2
    else if (i.eq.5) then
        IPd8
    else if (i.eq.6) then
        IPd7s1
    else if (i.eq.7) then
        IId7
    else if (i.eq.8) then
        IIId6
    else if (i.eq.9) then
        IIId5p1
    else if (i.eq.10) then
        IVd5
    else if (i.eq.11) then
        Vd4
    else if (i.eq.12) then
        VId3
    else if (i.eq.13) then
        VIId2
    else if (i.eq.14) then
        VIIId1
    else if (i.eq.15) then
        IXp6
    else if (i.eq.16) then
        Xp3
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),shifts=0.2,shiftp=0.2,thrdis=1.0;diis,1,1,15,1;maxit,100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
