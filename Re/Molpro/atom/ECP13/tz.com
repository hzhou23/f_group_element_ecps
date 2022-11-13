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
1, 14.00022674954528,  15.0
3, 12.99623478596275,  210.003401243179200
2, 4.04914816080926 , -7.97147186403506
2, 4.02762398102479 , -9.87925299085002
2
2, 11.41305252393264,  471.04136887655403
2, 3.96696845658809 , 17.86263561670916
2
2, 9.53397795877572 , 265.26672851316965
2, 4.98803656470393 , 48.50854118075404
2
2, 6.28107391593633 , 107.91928663066766
2, 4.17556135757672 , 31.43535854962401
2
2, 2.53877743187362 , 16.90372368721188
2, 4.02070015034615 , 17.85766400641521
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
