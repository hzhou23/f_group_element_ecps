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
ECP, Lu, 60, 3 ;
4
1, 10.52837009007923, 11.0
3, 14.86622019153146, 115.812070990871530
2, 3.57977634311843, -5.91996927484231
2, 1.78997484335725, -4.23944565411987
4
2, 7.631500, 141.300211
2, 3.815700, 3.493950
2, 11.51769683, -72.10943943 
2, 3.2, 14.0
4
2, 6.546300, 76.059248
2, 3.273100, 9.440662
2, 11.51769683, -72.10943943
2, 3.2, 14.0
4
2, 4.459700, 49.091473
2, 2.229800, -0.846410
2, 11.51769683, -72.10943943
2, 3.2, 14.0
include,../generate/messyminus.basis
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
    {rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
