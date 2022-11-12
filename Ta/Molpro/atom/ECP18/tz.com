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
1, 7.35783522180766 , 13.0
3, 5.40076820314812 , 95.651857883499580
2, 3.22307720038764 , -0.07893282121621
2, 2.95666554144618 , -8.57369790107260
4
2, 21.42048689050018,  455.06430372645593
4, 7.08651203984714 , 7.60448666650966
2, 1.78648831541817 , -6.07774270384344
2, 4.05054894445721 , 34.76208983655465
4
2, 11.19382486717620,  334.88205852882464
4, 9.90446979712992 , 9.66412424579889
2, 7.68067003989395 , -1.98403123865515
2, 4.01441016326656 , 1.49584776087929
4
2, 6.79027178668378 , 110.71898694307792
4, 3.10781234965810 , 3.46256636084654
2, 1.01000000143642 , -0.91211182193619
2, 3.56972931481443 , 16.92788635932609
2
2, 3.62501415455700 , 13.12223972828046
2, 1.92089124058188 , 12.75786332283285
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
        EAd5s1
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
