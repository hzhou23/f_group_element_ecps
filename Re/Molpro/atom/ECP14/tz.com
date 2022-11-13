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
1, 13.99291119644726,  15.0
3, 13.16490622126587,  209.893667946708900
2, 3.87331571280797 , -8.07685208267677
2, 3.65422647445502 , -9.99969366723489
2
2, 11.52741505871857,  471.04055986421770
2, 3.52193891828695 , 17.80888746509934
2
2, 9.67053377874090 , 265.26931814718881
2, 4.69321362788258 , 48.51541788146839
2
2, 6.20260651177507 , 107.92097886520729
2, 4.05488298460774 , 31.43796943420103
2
2, 2.50292205999714 , 16.90564448518640
2, 4.01397593729297 , 17.85814208198506
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
