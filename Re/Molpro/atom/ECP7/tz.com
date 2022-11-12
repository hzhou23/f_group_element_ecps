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
1, 14.43854659147721,  15.0
3, 13.70108435455064,  216.578198872158150
2, 3.29012267081750 , -5.49791114613269
2, 4.19180006657470 , -6.70046168985070
2
2, 12.10953143571472,  471.14756017907325
2, 3.41581208431076 , 15.23767681280703
2
2, 9.38138638056830 , 265.34191199047200
2, 5.25951321712640 , 49.14984326818383
2
2, 5.97608287438998 , 108.77986912107261
2, 4.73102802203891 , 33.35431558891830
2
2, 2.23002266600839 , 16.91896604085085
2, 4.13208395739172 , 17.85440910215242
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
