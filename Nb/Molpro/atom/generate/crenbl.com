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
2,3.44460011,-2.12992907;
2,9.11340046,-22.97262573;
2,22.98679924,-56.91117859;
2,76.26629639,-145.99894714;
1,234.28889465,-21.96123505;
7; !  s-ul potential
2,2.88310003,51.21849060;
2,3.43950009,-165.87748718;
2,4.80849981,353.43283081;
2,7.36780024,-339.01223755;
2,11.54769993,273.15057373;
1,37.81430054,19.10134315;
0,33.57780075,3.36632800;
7; !  p-ul potential
2,2.75320005,52.35134125;
2,3.24040008,-168.72013855;
2,4.41370010,349.30529785;
2,6.57270002,-368.03564453;
2,9.91119957,271.09564209;
1,29.60670090,13.24002266;
0,25.94729996,5.32180595;
7; !  d-ul potential
2,1.90470004,34.02252197;
2,2.22099996,-109.34761810;
2,2.94840002,211.43179321;
2,4.25290012,-270.02197266;
2,6.14580011,220.20515442;
1,18.43989944,11.01616001;
0,15.86740017,7.31999588;
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
