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
1 5.20982392529111  , 13.0
3, 5.09399548573342 , 67.727711028784430
2, 3.70445534660977 , -0.69133849935939
2, 2.38077411794044 , -5.81916968993469
4
2, 22.10053478788410,  454.94461998019756
4, 10.17315767085040,  3.58069870520996
2, 2.75203567230649 , -4.62461718596031
2, 5.46083131818003 , 32.22883204413273
4
2, 12.04028939214843,  335.40746473427475
4, 10.55513340252588,  9.56743534086559
2, 7.20809953078667 , -0.53106943341786
2, 4.76859380681340 , 7.52920695411258
4
2, 6.43795216578077 , 110.71219362448436
4, 3.69083081960298 , 2.97126768480741
2, 2.00599681610437 , -1.53926955759768
2, 4.54341748841160 , 16.08302174485260
2
2, 3.32364009622465 , 12.97554959926653
2, 2.02110996202473 , 12.71836444879025
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
