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
1, 13.77358518852697,  15.0
3, 12.81422618104271,  206.603777827904550
2, 3.45957382862448 , -6.18470841425567
2, 4.04830082872267 , -6.83888111232497
2
2, 12.12261064636563,  470.93626394316243
2, 3.40646927245008 , 15.07136483063432
2
2, 9.33615213729083 , 265.39981485722029
2, 5.33164404930460 , 49.65410113902736
2
2, 5.99503640543878 , 108.56708937780061
2, 4.67091887855632 , 32.90396929551129
2
2, 2.23776626687705 , 16.93058067341244
2, 4.08514696781550 , 17.85843486300441
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
