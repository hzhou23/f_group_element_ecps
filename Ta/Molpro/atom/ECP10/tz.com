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
1, 9.47589038609703 , 13.0
3, 6.54140679181925 , 123.186575019261390
2, 4.52381663213571 , -4.75476689603843
2, 5.32019300387546 , -7.52215904754007
4
2, 13.30709206680405,  254.43680839142809
4, 5.16919083250509 , 3.14665075411094
2, 2.56045311307125 , -3.05445640895647
2, 4.44233634992588 , 14.17137616368760
4
2, 10.54553425908456,  292.80643206598739
4, 8.94374511792760 , 11.08025469074613
2, 5.07032113270408 , -1.97562466338820
2, 5.20613448013150 , 12.12700154192318
4
2, 7.27399524667274 , 115.53495871907319
4, 5.88056778280685 , 1.28001658915173
2, 1.38757827083343 , 0.12720601860614
2, 4.57105174234466 , 12.41105074863345
2
2, 4.25990657907260 , 13.45980086759546
2, 2.04497793022864 , 13.01941999274742
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
