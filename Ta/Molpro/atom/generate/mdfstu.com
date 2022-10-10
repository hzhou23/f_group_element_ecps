***,Calculation for Ta atom, singlet and triplet
memory,1,g

gthresh,twoint=1.e-15
gthresh,oneint=1.e-15


geometry={
1
Ta
Ta  0.0 0.0 0.0
}

basis={
ECP,Ta,60,5,0;
1; 2,1.000000,0.000000; 
3; 2,10.318069,454.600649; 4,10.540267,2.837975; 2,2.574726,-0.814736; 
6; 2,8.743342,96.910783; 2,7.916223,195.850432; 4,9.275736,4.812524; 4,8.101675,6.338512; 2,2.077127,-0.459173; 2,2.750372,-0.644586; 
6; 2,5.447314,45.969976; 2,5.212545,69.638972; 4,5.884358,0.802933; 4,5.649579,0.429595; 2,1.388180,-0.307227; 2,1.294398,-0.461560; 
2; 2,2.161275,5.757773; 2,2.125939,7.678167; 
2; 2,3.145920,-5.684066; 2,3.127942,-7.062313; 
include,../generate/aug-cc-pwCVTZ.basis
}



include,../generate/Ta_states_ae.proc


do i=1,16
    if (i.eq.1) then
        Id3s2
    else if (i.eq.2) then
        Id4s1
    else if (i.eq.3) then
        EAd5s1
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
        IVf1
    else if (i.eq.10) then
        IVs1
    else if (i.eq.11) then
        IVp1
    else if (i.eq.12) then
        Vp6
    else if (i.eq.13) then
        VIIp4
    else if (i.eq.14) then
        VIIIp3
    else if (i.eq.15) then
        IXp2
    else if (i.eq.16) then
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
