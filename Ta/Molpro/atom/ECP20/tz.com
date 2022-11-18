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
1, 9.02483669066124 , 13.0
3, 7.57966033219298 , 117.322876978596120
2, 3.09577931086180 , -5.96735202482698
2, 2.84274457524598 , -7.71833726093112
4
2, 11.10177233425279,  454.41308667017898
4, 10.34757245374373,  1.50921054537365
2, 1.52333057764455 , -3.22625924662998
2, 2.86533950199432 , 16.50613958806080
4
2, 10.12142205421961,  292.47238178668704
4, 8.89409493904486 , 11.65040984818208
2, 4.50218862963327 , 4.33392525277766
2, 2.62710076360831 , 9.60385107703057
4
2, 5.25855346870556 , 115.45028390155834
4, 6.64365330402484 , 0.08239623135699
2, 1.01000000000000 , -1.06296597791394
2, 2.87609407268441 , 13.18451642585525
2
2, 2.02677105917727 , 13.56838314192661
2, 2.12809063242320 , 13.03206487275140
include,../generate/,aug-cc-pwCVTZ.basis
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
        EAd5s1
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
