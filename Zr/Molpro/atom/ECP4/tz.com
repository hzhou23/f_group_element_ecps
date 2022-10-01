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
ECP, zr, 28, 3
4
1, 23.99901156399985,  12.0
3, 25.97176391420234,  287.988138767998200
2, 4.92661418289814 , -5.98717813175362
2, 4.80138762543713 , -7.92258037931769
2
2, 8.76509116700506 , 150.26231364732385
2, 3.92832199983719 , 30.21371302162681
2
2, 7.41790671408941 , 99.30190953603842
2, 3.76873307676204 , 25.35602553401884
2
2, 2.25055569071831 , 5.60755696446559
2, 5.35535567613690 , 46.91683292558112
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
