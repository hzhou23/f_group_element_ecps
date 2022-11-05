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
1, 9.47593761498186 , 13.0
3, 6.68419469949979 , 123.187188994764180
2, 4.50279312969118 , -4.74450234479249
2, 5.30655820226264 , -7.50997700647287
4
2, 12.99704809105003,  254.44117827407013
4, 5.17136860328960 , 3.15492505348126
2, 2.45054847249734 , -2.97872515159949
2, 4.39704012056821 , 14.21049728428657
4
2, 10.84432505693473,  292.80358582740024
4, 8.95279612414518 , 11.07748307320084
2, 5.04909650824264 , -2.00408417489747
2, 5.33703107877786 , 12.10072941513010
4
2, 7.38065142842785 , 115.53299868389350
4, 5.88115958446283 , 1.27610040380508
2, 1.64547534200050 , 0.10554873080558
2, 4.60666591597648 , 12.40495137317063
2
2, 4.26313530385666 , 13.45945710075015
2, 2.18936895331619 , 13.01295858377072
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
