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
ECP,Zr,28,3
4
1, 16.98857135215762,  12.0
3, 16.45017512601250,  203.862856225891440
2, 4.17003168118445 , -13.49418435319915
2, 14.58119965632844,  -10.23466856641662
2
2, 9.00676171417253 , 150.09834066417420
2, 3.64409522087210 , 28.90663531474614
2
2, 7.59239715590237 , 99.35683485898602
2, 3.41969515065976 , 22.98527159164662
2
2, 2.31017546162010 , 7.16789331264605
2, 5.56384526072832 , 47.42620459352956
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
