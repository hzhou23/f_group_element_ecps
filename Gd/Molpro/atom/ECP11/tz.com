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
1, 4.03914948371655 , 18.0
3, 3.68719625767316 , 72.704690706897900
2, 5.26533197883416 , -79.84533669032790
2, 2.32940403292559 , -7.97027212697161
2
2, 15.11545316197370,  157.87730311140018
2, 4.25537332308656 , 53.17120222018482
2
2, 11.30392910122091,  86.60000666137128
2, 3.75020794642806 , 47.32605188049755
2
2, 8.68149177041521 , 54.55583822733098
2, 2.35146190541201 , 22.63293823670600
2
2, 3.23992163720239 , -26.05095723004601
2, 2.90252624234215 , -2.51581947967186
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
