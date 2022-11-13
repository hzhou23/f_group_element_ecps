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
1, 14.43859050560659,  15.0
3, 13.70010424744015,  216.578857584098850
2, 3.29949225443510 , -5.49542838823487
2, 4.19747661299732 , -6.69907643242339
2
2, 12.09962270113623,  471.14758011601452
2, 3.40670223061467 , 15.23862058351030
2
2, 9.37756238294759 , 265.34194798602869
2, 5.25346813206030 , 49.15007833631903
2
2, 5.96856851785967 , 108.77998936694145
2, 4.72533636571819 , 33.35457410112623
2
2, 2.23014944429660 , 16.91896014729894
2, 4.13209659525014 , 17.85440822965785
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
