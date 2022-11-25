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
1, 8.39889705784972 , 13.0
3, 7.34508858747240 , 109.185661752046360
2, 3.58829902764072 , -6.97440629535382
2, 2.46973293634240 , -9.09022805413226
4
2, 15.78382921365940,  354.34514560888709
4, 4.73299654451634 , -3.36121224192847
2, 6.40866955728764 , 14.71798806693422
2, 2.33777043037359 , 13.56757642346622
4
2, 7.38848525090080 , 292.77116311940819
4, 6.95182698215661 , -10.22964252943435
2, 4.81606144579728 , 5.35461472250129
2, 5.10997585329774 , 9.36442904833929
4
2, 4.76168106390609 , 115.85653524780594
4, 6.57681514153605 , -0.64282943675044
2, 9.87507973033334 , 5.37001991048952
2, 6.28708694756787 , 12.55035672640241
2
2, 1.80139659859822 , 13.58757735947614
2, 3.31603243473976 , 12.94364074434164
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
