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
1, 9.72977071251832 , 13.0
3, 9.04025305231791 , 126.487019262738160
2, 2.28219792500687 , -0.45936988031577
2, 6.18256528141011 , -9.37898519512449
4
2, 14.40648876085446,  899.78004593830656
4, 10.53949302502502,  1.51297812382423
2, 2.46281742879685 , -0.74728692809665
2, 4.80560319008407 , 11.03700907333499
4
2, 10.01200161024997,  334.61021017859207
4, 8.33437931127020 , 5.49792066023563
2, 3.74287984444098 , 3.37938227432620
2, 7.28096635039259 , 21.41871775905508
4
2, 5.81879520796742 , 110.20331903469437
4, 5.66431599759524 , 0.85608519669606
2, 1.05272337290654 , -0.53337130745784
2, 4.61685015411584 , 16.62468989969337
2
2, 1.99110702064689 , 12.75533125658117
2, 4.29972709599874 , 12.33234481127665
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
