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
1, 4.64649423380707,  18.0
3, 5.03898469561614,  83.636896208527260
2, 6.14922726155977,  -94.54346463109100
2, 5.39086597594697,  -9.07764978300212
2
2, 9.64508287717261,  160.08091893942253
2, 4.89569161141406,  82.16244181564230
2
2, 7.84634259934576,  88.42449114602753
2, 3.73740426162130,  54.36568213794933
2
2, 9.87079385121206,  55.57793911614991
2, 2.47059638061654,  31.33022231606614
2
2, 3.70555603254771,  -25.69937903186067
2, 6.16350930047429,  -4.52646585527923
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
