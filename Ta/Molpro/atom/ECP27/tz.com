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
1, 12.82539658819463,  13.0
3, 11.70309325467236,  166.730155646530190
2, 5.03082579399285 , -4.66790331635790
2, 2.15721943266161 , -1.62554684483801
2
2, 11.67567705967940,  459.21736879071398
2, 2.70754241296273 , 5.93280127675433
2
2, 8.47901944560844 , 379.80916356608083
2, 9.33899700746909 , 37.09249334000437
2
2, 6.75419267385631 , 108.30421504871508
2, 3.65435850888707 , 21.91373762797083
2
2, 6.81091791316786 , 11.99967767737882
2, 1.59592986373716 , 11.97548909477149
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
