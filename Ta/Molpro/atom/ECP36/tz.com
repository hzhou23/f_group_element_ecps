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
1, 8.39591855732551 , 13.0
3, 7.37286292331927 , 109.146941245231630
2, 3.59266705502262 , -6.97786880776556
2, 2.53002503347401 , -9.09058904984734
4
2, 15.78265881902567,  354.34497747304079
4, 4.73140156155340 , -3.36291197424236
2, 6.42249834782783 , 14.71521735205340
2, 2.33565669349034 , 13.55853730869270
4
2, 7.33406657797382 , 292.77152864401853
4, 6.95327134879809 , -10.22941613131565
2, 4.81114762146012 , 5.35609845909410
2, 5.10296315262077 , 9.36567288273615
4
2, 4.74986524110138 , 115.85664839865098
4, 6.57684486761806 , -0.64294908031154
2, 9.87507291582495 , 5.36997948266981
2, 6.28679629657445 , 12.55040487466287
2
2, 1.80212831289435 , 13.58754476820762
2, 3.31609402113527 , 12.94363624966530
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
