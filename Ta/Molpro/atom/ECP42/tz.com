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
ECP, ta, 60, 4 ;
4
1, 5.51381162481927 , 13.0
3, 7.44023688553307 , 71.679551122650510
2, 6.46711456726471 , -4.30699257466320
2, 2.49908906750668 , 1.234000000000000
4
2, 15.58862294664662,  354.58930661569656
4, 2.75577479494782 , -6.05061900298280
2, 10.65475241520931,  15.35411289400539
2, 5.17511570569688 , 24.78696761179354
4
2, 11.09310542636039,  290.21967880128466
4, 8.73534400244057 , -12.51869998550155
2, 1.01000000000000 , -5.41857066734325
2, 1.44190924855287 , 9.48101569380436
4
2, 6.48219541530707 , 122.22049919163408
4, 8.96694219606174 , -9.72701595043986
2, 5.50755923860412 , 5.40961379771644
2, 7.61430452006915 , 14.93802490219636
2
2, 1.92694647065041 , 13.61349229546305
2, 4.70373773488592 , 12.89155307351928
include,../generate/aug-cc-pwCVTZ.basis
}



include,../generate/Ta_states_ae.proc


do i=1,13
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
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
