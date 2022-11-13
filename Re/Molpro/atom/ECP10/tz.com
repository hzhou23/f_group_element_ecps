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
1, 14.43858197730554,  15.0
3, 13.70029595165646,  216.578729659583100
2, 3.29927516253229 , -5.49558039074243
2, 4.19727014932439 , -6.69918694544007
2
2, 12.12898731781881,  471.14756452551740
2, 3.40947247372684 , 15.23822449182867
2
2, 9.37609131276246 , 265.34196323120545
2, 5.25149797523208 , 49.15016358664734
2
2, 5.96762049304627 , 108.78000399173234
2, 4.72455762739864 , 33.35460647885711
2
2, 2.23009559091282 , 16.91896265085092
2, 4.13209123073181 , 17.85440860074520
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
