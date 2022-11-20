***,Calculation for Gd atom, singlet and triplet
memory,1,g

gthresh,twoint=1.e-15
gthresh,oneint=1.e-15


geometry={
1
Gd
Gd  0.0 0.0 0.0
}

basis={
ECP, Gd, 46, 4 ;
4
1, 4.43847697809419 , 18.0
3, 4.20947620118637 , 79.892585605695420
2, 5.05705672412280 , -84.51410909457563
2, 2.06492717079671 , -4.52664379059650
2
2, 9.50666165342855 , 160.81006455276994
2, 4.78830349377954 , 88.07892187531722
2
2, 8.19481079603538 , 89.44959622330910
2, 3.73065653663183 , 60.10169063983067
2
2, 10.00000000000000,  55.67296178994840
2, 2.25184500980458 , 27.91217655615637
2
2, 4.16846580351090 , -22.68626467717559
2, 3.40806690347195 , -5.21969343226485
include,../generate/aug-cc-pwCVTZ_ecp.basis
}



include,../generate/Gd_states_ae.proc

do i=1,12
    if (i.eq.1) then
        Id1f7s2
    else if (i.eq.2) then
        Id2f7s1
    else if (i.eq.3) then
        Ip1f7s2
    else if (i.eq.4) then
        EAd2f7s2
    else if (i.eq.5) then
        IId1f7s1
    else if (i.eq.6) then
        IIdf7s2
    else if (i.eq.7) then
        IIId1f7
    else if (i.eq.8) then
        IIIp1f7
    else if (i.eq.9) then
        IVdf7
    else if (i.eq.10) then
        Vdf6
    else if (i.eq.11) then
        VIdf5
    else if (i.eq.12) then
        VIIdf4
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
