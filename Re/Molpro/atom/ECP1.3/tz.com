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
1, 10.79060361129457,  15.0
3, 8.58824174811057 , 161.859054169418550
2, 3.67723395545069 , -12.15295891341798
2, 3.94795680111359 , -12.16979418822632
2
2, 11.17059061629397,  349.55961709990612
2, 3.26820192603944 , 15.06864089973130
2
2, 8.55033731245932 , 339.73293963850978
2, 5.82193902103292 , 42.30328642665054
2
2, 7.32938673660753 , 110.47431041603257
2, 3.03556110426896 , 20.41803460953421
2
2, 2.41929012999010 , 16.48293846030001
2, 3.59710207077404 , 16.52537206187579
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
