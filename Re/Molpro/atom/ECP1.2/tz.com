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
1, 9.20761727233161 , 15.0
3, 8.69674131900234 , 138.114259084974150
2, 3.01319002821308 , -10.16399504874812
2, 4.66575497930990 , -7.75988144056642
2
2, 12.63238372032797,  349.65442121292870
2, 3.40122154203331 , 19.65831124498570
2
2, 9.81696143671290 , 339.58091274682283
2, 4.81024776045297 , 41.06872099172463
2
2, 7.32408280109972 , 111.58580911493202
2, 3.41848195993421 , 27.15043241463062
2
2, 2.19500650073756 , 16.47982301672791
2, 3.70845189248067 , 16.51475535748299
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
