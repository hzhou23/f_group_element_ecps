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
2,1.34420002,-0.63006300;
2,3.63630009,-10.51489067;
2,9.45650005,-58.95209122;
2,25.35820007,-115.01941681;
2,83.40769959,-347.15853882;
1,276.78070068,-49.26778412;
8; !  s-ul potential
2,2.36209989,-44.26672363;
2,2.72939992,129.19606018;
2,3.67540002,-242.92758179;
2,5.53210020,501.74584961;
2,8.98340034,-445.97048950;
2,15.25590038,394.00692749;
1,50.81330109,26.49606895;
0,35.46549988,6.66976500;
8; !  p-ul potential
2,2.03469992,-40.03034592;
2,2.35809994,126.64355469;
2,3.05710006,-228.62715149;
2,4.39909983,402.92218018;
2,6.61850023,-364.56909180;
2,10.01210022,314.11911011;
1,25.28219986,41.13771057;
0,38.69940186,5.77764893;
8; !  d-ul potential
2,1.33980000,-19.84150887;
2,1.50170004,41.82987595;
2,2.26449990,-115.67475128;
2,3.06690001,256.13897705;
2,4.50220013,-264.05648804;
2,6.76459980,231.04666138;
1,15.22159958,28.69319344;
0,21.53820038,7.87635279;
8; !  f-ul potential
2,1.48140001,-69.01650238;
2,1.68589997,172.23371887;
2,2.11229992,-173.36340332;
2,2.64039993,97.75544739;
2,9.64130020,78.55423737;
2,24.78100014,126.52191925;
1,57.28340149,37.84556961;
0,142.22329712,0.79649299;
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
