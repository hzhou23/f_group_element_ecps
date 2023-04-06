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
1, 17.28110780023276,  11.0
3, 13.60697135160765,  190.092185802560360
2, 4.57738051213864 , -3.02393319484724
2, 4.75221453740503 , -3.18193552549651
2
2, 8.26996354320974 , 478.82619391537463
2, 7.60510833868377 , 53.10378556831883
2
2, 8.23043821082899 , 260.82941073554593
2, 6.61376669146492 , 44.32969523987585
2
2, 6.27756651863690 , 104.38318687405372
2, 7.65990954947593 , 19.01993852856829
2
2, 4.28754796670846 , 16.96876868267619
2, 4.12525421390907 , 17.69834991823300
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
