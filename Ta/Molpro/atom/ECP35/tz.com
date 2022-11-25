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
1, 8.39591014779667 , 13.0
3, 7.37294320814690 , 109.146831921356710
2, 3.59221780807861 , -6.97792175162901
2, 2.52714088025842 , -9.09081033069424
4
2, 15.78273537078577,  354.34497639412774
4, 4.73133350553020 , -3.36294197119922
2, 6.42265652095553 , 14.71519505791172
2, 2.33873850112960 , 13.55826468996918
4
2, 7.33013585093530 , 292.77155493326347
4, 6.95337306366276 , -10.22939946479996
2, 4.81078501773162 , 5.35620738155931
2, 5.10244718052372 , 9.36576361416662
4
2, 4.75623265887059 , 115.85657387873145
4, 6.57683864415208 , -0.64294126873341
2, 9.87508201866972 , 5.36997647542533
2, 6.28700101346890 , 12.55037797458292
2
2, 1.80211730344282 , 13.58754525043438
2, 3.31609311752469 , 12.94363631565316
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
