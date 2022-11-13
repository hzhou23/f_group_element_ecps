***,Calculation for Re atom, singlet and triplet
memory,1,g

gthresh,twoint=1.e-15
gthresh,oneint=1.e-15


geometry={
1
Re
Re  0.0 0.0 0.0
}

basis={
ECP, re, 60, 4 ;
4
1, 14.43856838896161,  15.0
3, 13.70063963221794,  216.578525834424150
2, 3.29448755986563 , -5.49658344993933
2, 4.19578759025400 , -6.69954550748515
2
2, 12.11434273023976,  471.14751693586493
2, 3.40222480581405 , 15.23831203950330
2
2, 9.36921557068957 , 265.34205969356907
2, 5.25038039944097 , 49.15044049714530
2
2, 5.96755183184084 , 108.77998426175050
2, 4.72292506038265 , 33.35459697170005
2
2, 2.22898187263090 , 16.91901443256149
2, 4.13198027481934 , 17.85441627608173
include,../generate/aug-cc-pwCVTZ.basis
}



include,../generate/Re_states_ae.proc

do i=1,15
    if (i.eq.1) then
        Id5s2
    else if (i.eq.2) then
        Id6s1
    else if (i.eq.3) then
        EAd6s2
    else if (i.eq.4) then
        IPd5s1
    else if (i.eq.5) then
        IPd5p1
    else if (i.eq.6) then
        IId5
    else if (i.eq.7) then
        IIId4
    else if (i.eq.8) then
        IVd3
    else if (i.eq.9) then
        Vd2
    else if (i.eq.10) then
        VId1
    else if (i.eq.11) then
        VIpf1
    else if (i.eq.12) then
        VIp1
    else if (i.eq.13) then
        VIIp6
    else if (i.eq.14) then
        VIIIp4
    else if (i.eq.15) then
        IXp3
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
