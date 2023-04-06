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
ECP,Lu,46,4,0;
4
1, 3.14833474446234,  25.0
3, 2.65115497652619,  78.7083686115585
2, 2.78295903287120,  -72.60509167627022
2, 3.46628519446209,  -2.15683842991001
2
2, 5.79136585352643,  250.310476835938
2, 3.07955851231268,  11.4226597920253
2
2, 3.72571172950070,  61.7986494141870
2, 4.05271563112787,  47.2939639434762
2
2, 2.52321040379140,  25.8874030444728
2, 3.47082531866092,  35.4288883812381
2
2, 5.03278656337232,  -3.36898369803320
2, 3.20307702617417,  -1.22025489182895
include,../aug-cc-pwCVTZ.basis
}



include,../Lu46_states_ecp.proc

do i=12,12
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
