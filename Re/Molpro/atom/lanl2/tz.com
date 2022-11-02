***,Calculation for Re atom, singlet and triplet
memory,1,g

gthresh,twoint=1.e-15
gthresh,oneint=1.e-15


geometry={
1
Re
Re  0.0 0.0 0.0
}

basis={
ECP, re, 60, 4 ;
6; !  ul potential
1,1833.8143836,-0.1497104;
2,414.0589456,-1669.2555781;
2,59.0349540,-346.6661129;
2,11.9177094,-96.6684892;
2,3.6531764,-11.0738567;
2,1.2764184,-0.5798552;
7; !  s-ul potential
0,247.0023085,3.1497104;
1,631.7195767,45.2969969;
2,249.2800441,1116.4279585;
2,84.2947315,793.6419065;
2,23.0407912,318.2099193;
2,4.2997111,586.3105025;
2,4.0974390,-475.6904164;
5; !  p-ul potential
0,193.6897726,2.1497104;
1,56.9308394,64.2295736;
2,18.7227602,218.8504607;
2,3.7340020,344.4189168;
2,3.5127483,-260.4727267;
5; !  d-ul potential
0,126.2340824,3.1497104;
1,80.7090826,46.5714868;
2,42.5529714,304.3834595;
2,13.4074494,157.1589652;
2,3.6904228,48.5701211;
5; !  f-ul potential
0,112.7786459,3.9569610;
1,56.7815968,52.3586781;
2,28.5831966,236.0340824;
2,8.5734158,116.5787266;
2,2.0892721,11.1050530;
include,../generate/aug-cc-pwCVTZ.basis
}



include,../generate/Re_states_ae.proc

do i=1,15
    if (i.eq.1) then
        Id5s2
    else if (i.eq.2) then
        Id6s1
    else if (i.eq.3) then
        EAd6s2
    else if (i.eq.4) then
        IPd5s1
    else if (i.eq.5) then
        IPd5p1
    else if (i.eq.6) then
        IId5
    else if (i.eq.7) then
        IIId4
    else if (i.eq.8) then
        IVd3
    else if (i.eq.9) then
        Vd2
    else if (i.eq.10) then
        VId1
    else if (i.eq.11) then
        VIpf1
    else if (i.eq.12) then
        VIp1
    else if (i.eq.13) then
        VIIp6
    else if (i.eq.14) then
        VIIIp4
    else if (i.eq.15) then
        IXp3
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
