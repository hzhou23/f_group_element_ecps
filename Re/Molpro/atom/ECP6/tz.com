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
1, 14.43853095237260,  15.0
3, 13.70143588935427,  216.577964285589000
2, 3.28549604889306 , -5.49901994436885
2, 4.18919552256709 , -6.70104634073794
2
2, 12.10375736803952,  471.14755375368770
2, 3.41886432084825 , 15.23736477202774
2
2, 9.38164223025465 , 265.34190992064919
2, 5.26002300808552 , 49.14982574026606
2
2, 5.98320962505167 , 108.77975533915463
2, 4.73643064550793 , 33.35407025792746
2
2, 2.22984805639770 , 16.91897415701144
2, 4.13206655702579 , 17.85441030398715
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
