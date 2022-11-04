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
1, 9.49594023190898 , 13.0
3, 6.50213664288903 , 123.447223014816740
2, 4.55207617239207 , -4.73322703998514
2, 5.34492732203557 , -7.50464766318908
4
2, 13.07454881136209,  254.44003651814958
4, 5.18791160933069 , 3.14821025129681
2, 2.36469078852815 , -3.03647119047403
2, 4.52758904935943 , 14.18948675412584
4
2, 10.66539913093377,  292.80520935255618
4, 8.94566364427656 , 11.07885341780337
2, 5.07244378444537 , -1.98312762653506
2, 5.20852558990916 , 12.11985258818453
4
2, 7.34000171030301 , 115.53367911512949
4, 5.88034631027534 , 1.27689567773619
2, 1.63616622242908 , 0.15509416503100
2, 4.57636420762624 , 12.40846350156638
2
2, 4.26286799231895 , 13.45947945379355
2, 2.18505109857281 , 13.01318709804272
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
