***,Calculation for Y atom, singlet and triplet
memory,1,g
geometry={
1
Y
Y  0.0 0.0 0.0
}

gthresh,twoint=1.0E-15
gthresh,oneint=1.0E-15


basis={
ECP,Y,28,4,3;
1; 2,1.000000,0.000000; 
2; 2,7.858275,135.134974; 2,3.382128,15.411632; 
4; 2,6.849791,29.251437; 2,6.710092,58.508363; 2,3.042159,3.780243; 2,2.937330,7.676547; 
4; 2,5.416315,11.849911; 2,5.333416,17.778103; 2,1.976212,2.062383; 2,1.961111,3.075654; 
2; 2,5.028590,-6.928078; 2,5.005582,-9.155099; 
4; 2,6.849791,-58.502875; 2,6.710092,58.508363; 2,3.042159,-7.560487; 2,2.937330,7.676547; 
4; 2,5.416315,-11.849911; 2,5.333416,11.852069; 2,1.976212,-2.062383; 2,1.961111,2.050436; 
2; 2,5.028590,4.618718; 2,5.005582,-4.577550; 
include,aug-cc-pwCVTZ.basis
}

include,states.proc
    
do i=1,15
    if (i.eq.1) then
        Id1s2
    else if (i.eq.2) then
        Is2p1
    else if (i.eq.3) then
        EAd2s2
    else if (i.eq.4) then
        IIds2
    else if (i.eq.5) then
        IId1s1
    else if (i.eq.6) then
        IIId1s
    else if (i.eq.7) then
        IIIp1s
    else if (i.eq.8) then
        IIIsf1
    else if (i.eq.9) then
        IVd
    else if (i.eq.10) then
        Vp5
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
    {rccsd(t),shifts=0.2,shiftp=0.2,thrdis=1.0;diis,1,1,15,1;maxit,100;core
    orbital,ignore_error}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save 
