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
1 8.39600579483612  13.0
3 7.37183738092785  109.148075332869560
2 3.59420250672923  -6.97760446834849
2 2.53553655796277  -9.08992515687905
4
2 15.77404745214733  354.34497726963627
4 4.73151965524271  -3.36287649403606
2 6.42239944060001  14.71521955511648
2 2.32994046862664  13.55892748683944
4
2 7.33144203381817  292.77154646752041
4 6.95334051230636  -10.22940515651113
2 4.81090609552060  5.35617134736248
2 5.10262053551315  9.36573321592415
4
2 4.74995250742888  115.85664824979435
4 6.57684511405943  -0.64293530019863
2 9.87507257924310  5.36997846374246
2 6.28679531544155  12.55040524234823
2
2 1.80236598276304  13.58753422933148
2 3.31611398309890  12.94363478130705
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
