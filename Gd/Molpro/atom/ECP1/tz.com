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
1, 14.29616810964936,  18.0
3, 13.66875489811423,  257.331025973688480
2, 6.43399516703776 , -73.01961751504025
2, 3.95128011913650 , -12.21962987363930
2
2, 5.51999350573051 , 175.38930103311685
2, 4.00864280895584 , 28.72161073180251
2
2, 4.46833538701836 , 144.28496332273906
2, 13.17218778545907,  20.41694617388933
2
2, 5.33735274705514 , 102.12120033352411
2, 2.16755423648829 , 20.13341484923705
2
2, 15.55863046341882,  20.12325595330081
2, 15.30016100366447,  76.81861611881776
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
