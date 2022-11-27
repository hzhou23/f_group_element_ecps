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
1, 7.33443177733808 , 13.0
3, 9.71757435331864 , 95.347613105395040
2, 9.51350089152299 , -0.32384053030616
2, 1.02496833567370 , -0.32012490977607
4
2, 14.63435972541884,  355.04318756605238
4, 6.87015783738479 , -2.74998800080418
2, 8.58234570787466 , 23.42157796064991
2, 5.43562273337292 , 24.77347743794243
4
2, 10.05271468284698,  290.75148331430199
4, 11.20185826698038,  -11.34246159786968
2, 4.23576644325000 , -0.03933469194769
2, 3.04173328136949 , 5.84602514420940
4
2, 5.91505974651468 , 120.30042050468550
4, 3.40826061855330 , -6.82770773408640
2, 4.01110158619859 , 7.58434972086854
2, 5.89308520493976 , 16.61999819794593
2
2, 1.88276693833787 , 13.83995611471672
2, 5.12359135990143 , 12.85436403353524
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
