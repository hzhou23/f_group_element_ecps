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
0,600.3243032,-0.0538958;
1,157.6910176,-20.1316282;
2,49.8841995,-105.3654121;
2,15.5966895,-42.3274370;
2,5.5099296,-3.6654043;
5; !  s-ul potential
0,59.3442526,2.9753728;
1,83.7426061,25.1230306;
2,18.4530248,626.0926145;
2,12.4194606,-812.2549385;
2,8.8172913,467.3729340;
5; !  p-ul potential
0,53.4309068,4.9537213;
1,65.6671843,20.4871116;
2,16.8369862,598.0120139;
2,11.3042136,-718.4059028;
2,8.0312444,382.8173151;
4; !  d-ul potential
0,64.3993653,3.0279532;
1,43.4625053,24.7526516;
2,19.4020301,142.6844289;
2,4.6879328,32.1406857;
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
