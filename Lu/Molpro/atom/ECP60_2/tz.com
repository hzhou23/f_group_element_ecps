***,Calculation for Lu atom, singlet and triplet
memory,1,g

gthresh,twoint=1.e-15
gthresh,oneint=1.e-15


geometry={
1
Lu
Lu  0.0 0.0 0.0
}

basis={
ECP, Lu, 60, 4 ;
4
1,  15.28440259526261, 11.0
3,  12.57643855801481, 168.128428547888710
2,  4.89951641455830 , -7.06296873511447
2,  4.58599893504871 , -4.35500944858352
2
2,  14.87229120189673, 470.61534293686435
2,  8.75060718690670 , 170.12357705579251
2
2,  8.12000000000000 , 222.37803784363908
2,  3.85150180895597 , 14.03440397686128
2
2,  6.84296274925732 , -34.40717670689995
2,  2.81436321039149 , 16.93461134095244
2
2,  4.63137151920054 , 8.42650749374809
2,  2.51826354979973 , -28.03312243523867
include,../generate/aug-cc-pwCVTZ.basis
}



include,../generate/Lu60_states_ecp.proc

do i=1,17
    if (i.eq.1) then
        Id1s2
    else if (i.eq.2) then
        Ip1s2
    else if (i.eq.3) then
        IEd2s1
    else if (i.eq.4) then
        IEf1s2
    else if (i.eq.5) then
        IIds2
    else if (i.eq.6) then
        IId1s1
    else if (i.eq.7) then
        IIIds1
    else if (i.eq.8) then
        IIIp1
    else if (i.eq.9) then
        IIId1
    else if (i.eq.10) then
        IIIEf1
    else if (i.eq.11) then
        VIp6
    else if (i.eq.12) then
        VIIp5
    else if (i.eq.13) then
        VIIIp4
    else if (i.eq.14) then
        IXp3
    else if (i.eq.15) then
        Xp
    else if (i.eq.16) then
        XIds2
    else if (i.eq.17) then
        IIIEf2
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),shifts=2.5,shiftp=1.5,thrdis=1.0;diis,1,1,15,1;maxit,100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
