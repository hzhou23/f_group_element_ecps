***,Calculation for Zr atom, singlet and triplet
memory,1,g
geometry={
1
Zr
Zr  0.0 0.0 0.0
}

gthresh,twoint=1.0E-15
gthresh,oneint=1.0E-15


basis={
ECP, zr, 28, 3
4
1, 23.98476208238715,  12.0
3, 23.01776229670372,  287.817144988645800
2, 6.06753386438658 , -21.53733472988625
2, 5.10507078197597 , -6.74380181397835
2
2, 8.24350687194227 , 171.36799532179566
2, 3.59298448090341 , 21.03387753855850
2
2, 7.16208556194354 , 120.89174447211511
2, 3.62225632689599 , 19.00915346207001
2
2, 5.67089063348319 , 55.76786292030541
2, 2.88250011779984 , 10.05938774444057
include,../generate/Zr-aug-cc-pwCVTZ.basis
}

include,../generate/Zr_states_ecp.proc

do i=1,15
    if (i.eq.1) then
        Id2s2
    else if (i.eq.2) then
        Id3s1
    else if (i.eq.3) then
        EAd3s2
    else if (i.eq.4) then
        IPd2s1
    else if (i.eq.5) then
        IPd3
    else if (i.eq.6) then
        IId2
    else if (i.eq.7) then
        IIId1
    else if (i.eq.8) then
        IIIp1
    else if (i.eq.9) then
        III_f1
    else if (i.eq.10) then
        IVp6
    else if (i.eq.11) then
        VIp4
    else if (i.eq.12) then
        VIIp3
    else if (i.eq.13) then
        VIIIp2
    else if (i.eq.14) then
        IXp1
    else if (i.eq.15) then
        Xp
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),shifts=0.2,shiftp=0.2,thrdis=1.0;diis,1,1,15,1;maxit,100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
