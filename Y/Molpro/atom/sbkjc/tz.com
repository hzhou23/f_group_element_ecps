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
ECP, y, 28, 3 ;
1;
1,3.1332300,-3.7082700;
3;
0,0.7473400,3.5245800;
2,2.1104600,-115.6779500;
2,2.3743100,141.6655100;
3;
0,0.8292400,3.4531900;
2,1.9297300,-67.4619200;
2,2.2037900,85.0945300;
2;
0,9.3677000,2.2959000;
2,2.8303800,20.6218200;
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
