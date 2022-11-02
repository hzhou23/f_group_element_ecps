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
1, 9.49311870686345 , 13.0
3, 6.52085529849528 , 123.410543189224850
2, 4.54852724216442 , -4.73449078734683
2, 5.34172619172436 , -7.50546013436257
4
2, 13.07873302279085,  254.43997717456551
4, 5.18864520513627 , 3.14777906501094
2, 2.35669487597898 , -3.04066903258018
2, 4.53637010512491 , 14.18820643516677
4
2, 10.65795736184987,  292.80527884557421
4, 8.94538106190875 , 11.07890812713315
2, 5.07331737044059 , -1.98540228568533
2, 5.20359658533699 , 12.12061308662383
4
2, 7.35217409620405 , 115.53347576181459
4, 5.88059141872319 , 1.27662077230424
2, 1.63874139966544 , 0.14015790891126
2, 4.58548053505171 , 12.40740543214276
2
2, 4.26280044576577 , 13.45948521384453
2, 2.18394889531236 , 13.01324535814453
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
