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
1, 4.00344854305685  ,  18.0
3, 3.60717766063765  ,  72.062073775
2, 5.21365732868997  ,  -102.20002007755825
2, 2.18770217170469  ,  -14.75807024866064
2
2, 15.19768280892150 ,  164.26842010886315
2, 4.22792214772802  ,  94.10201308425050
2
2, 11.34094238963603 ,  85.78533109242058
2, 3.71806799706924  ,  80.17668767976696
2
2, 8.48307462992686  ,  52.37778970757638
2, 2.34176280592863  ,  33.91095382043715
2
2, 3.25436714839169  ,  -5.98801545860119
2, 2.89616097318773  ,  -0.04688074964155
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
