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
1, 8.39619309140809 , 13.0
3, 7.36992397024221 , 109.150510188305170
2, 3.59518841220200 , -6.97726518693205
2, 2.53677260839851 , -9.08942389585096
4
2, 15.79093928474706,  354.34498288558484
4, 4.73173025972451 , -3.36276669765253
2, 6.42174108122632 , 14.71532838566159
2, 2.32252805796118 , 13.55978504848528
4
2, 7.34663031495202 , 292.77156028201830
4, 6.95339444124924 , -10.22939642278778
2, 4.81071656533567 , 5.35622798324612
2, 5.10235013514467 , 9.36578075512708
4
2, 4.75655342485759 , 115.85657007036401
4, 6.57683874163726 , -0.64295148548811
2, 9.87508313993774 , 5.36997400882924
2, 6.28701260750721 , 12.55037723846012
2
2, 1.80236295877641 , 13.58753436362208
2, 3.31611372941656 , 12.94363480028320
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
