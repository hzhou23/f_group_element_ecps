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
4
1, 14.05018977873791,  15.0
3, 12.76891924792041,  210.752846681068650
2, 3.59570794249007 , -7.54048175432679
2, 3.35047655752209 , -9.52867960497132
2
2, 11.63364570916874,  470.97279715848964
2, 2.99054074864310 , 14.79694543143510
2
2, 8.96668367023625 , 265.36144024810972
2, 4.89384920293343 , 49.48752430440230
2
2, 6.33251340074305 , 108.02686814959175
2, 3.82953076591716 , 31.99451787475527
2
2, 2.27551705833212 , 16.92023016843453
2, 3.94567742831904 , 17.86308986904444
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
