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
ECP, rh, 36, 3 ;
5; !  ul potential
2,0.84579998,-0.92449600;
2,2.08389997,-7.14187098;
2,6.52729988,-21.23577690;
2,20.22669983,-85.08799744;
1,64.99040222,-24.24301338;
7; !  s-ul potential
2,1.06579995,-77.58691406;
2,1.21669996,240.80317688;
2,1.53530002,-278.74105835;
2,2.08360004,215.33572388;
2,2.96230006,-114.76507568;
1,3.09660006,36.79577255;
0,15.23849964,3.33553004;
7; !  p-ul potential
2,0.89630002,-59.61508942;
2,1.03649998,208.17607117;
2,1.34590006,-285.84307861;
2,1.86530006,259.17666626;
2,2.50020003,-118.67604828;
1,3.80550003,28.71784782;
0,13.41059971,5.17818499;
7; !  d-ul potential
2,0.48629999,-0.35453799;
2,0.26460001,-0.03887800;
2,2.98650002,-83.94521332;
2,3.98250008,205.58543396;
2,5.47550011,-192.86888123;
1,8.45230007,18.63974380;
0,1.47650003,6.65249395;
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
    {rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;thresh,coeff=1d-3,energy=1d-5;diis,1,1,15,1;maxit,200;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
