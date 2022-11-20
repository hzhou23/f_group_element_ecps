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
1, 4.50047035517714,  18.0
3, 5.43280383278497,  81.008466393188520
2, 5.48845571513555,  -85.53847927985893
2, 3.17105972016277,  -2.97635713345808
2
2, 9.21360958339610,  161.11483551473421
2, 4.66816719788343,  89.32559263662480
2
2, 7.56812155802422,  88.69689551342759
2, 3.63275211228789,  57.11698448413326
2
2, 7.62967833049220,  55.89438924641517
2, 2.32490599667882,  29.31424157184773
2
2, 4.94057055411108,  -23.76224562777978
2, 3.63358249935201,  -6.91613803512643
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
