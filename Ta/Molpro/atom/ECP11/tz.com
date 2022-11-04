***,Calculation for Ta atom, singlet and triplet
memory,1,g

gthresh,twoint=1.e-15
gthresh,oneint=1.e-15


geometry={
1
Ta
Ta  0.0 0.0 0.0
}

basis={
ECP, ta, 60, 4 ;
4
1, 9.48388478772007 , 13.0
3, 6.69395502611293 , 123.290502240360910
2, 3.84564846737412 , -4.83060140428166
2, 4.74329792329606 , -7.56623967331896
4
2, 12.08070487785103,  254.45008494340559
4, 5.25937380175783 , 3.13331584243314
2, 2.86496852384317 , -2.52182496924177
2, 4.95043584883815 , 14.19625032387860
4
2, 10.48690162330973,  292.80916800034873
4, 8.92737654563204 , 11.08122839018250
2, 5.12940271945628 , -1.90960957735751
2, 5.29711641515450 , 12.13177510299480
4
2, 6.47931667618884 , 115.54885178432272
4, 5.88342252261920 , 1.25606362129650
2, 1.44034665441339 , -0.59901339889801
2, 4.49651531729617 , 12.46122741500653
2
2, 4.31516890661817 , 13.45463417774284
2, 2.51136393398202 , 12.99026601442901
include,../generate/aug-cc-pwCVTZ.basis
}



include,../generate/Ta_states_ae.proc


do i=1,16
    if (i.eq.1) then
        Id3s2
    else if (i.eq.2) then
        Id4s1
    else if (i.eq.3) then
        EAd5s1
    else if (i.eq.4) then
        IPd4
    else if (i.eq.5) then
        IPd3s1
    else if (i.eq.6) then
        IId3
    else if (i.eq.7) then
        IIId2
    else if (i.eq.8) then
        IVd1
    else if (i.eq.9) then
        IVf1
    else if (i.eq.10) then
        IVs1
    else if (i.eq.11) then
        IVp1
    else if (i.eq.12) then
        Vp6
    else if (i.eq.13) then
        VIIp4
    else if (i.eq.14) then
        VIIIp3
    else if (i.eq.15) then
        IXp2
    else if (i.eq.16) then
        XIp
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
