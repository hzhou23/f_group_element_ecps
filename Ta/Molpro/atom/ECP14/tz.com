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
1, 9.47542488781723 , 13.0
3, 6.69638523920446 , 123.180523541623990
2, 4.49665188987648 , -4.74557294171347
2, 5.30234697006755 , -7.51033246908528
4
2, 12.98757659063021,  254.44131772608694
4, 5.17648717888461 , 3.15577270320956
2, 2.46430257337332 , -2.97108487311425
2, 4.38156727576169 , 14.21301049236293
4
2, 10.85433613775534,  292.80349866418817
4, 8.95319690470203 , 11.07740577773581
2, 5.04773343191292 , -2.00527054255383
2, 5.34475616661697 , 12.09962007935479
4
2, 7.40231078774127 , 115.53263438293220
4, 5.88160011745925 , 1.27562444911800
2, 1.64930583666440 , 0.07883881063929
2, 4.62279215188138 , 12.40307009357823
2
2, 4.26309031604805 , 13.45946109609858
2, 2.18866111514022 , 13.01299649099056
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
