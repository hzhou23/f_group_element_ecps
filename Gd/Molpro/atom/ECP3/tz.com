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
1, 14.44827616953037,  18.0
3, 25.00000000000000,  260.068971051546660
2, 6.58500253307162 , -74.81792954679725
2, 11.83286576155189,  -14.66432915603376
2
2, 5.95179659914959 , 175.37630879182774
2, 3.74160184127504 , 28.75876273273460
2
2, 4.52058401854461 , 144.25637218374757
2, 13.17398522305329,  20.41606271277533
2
2, 9.40953469392961 , 101.99125511678389
2, 1.79472601873722 , 18.67859499435702
2
2, 17.09111277985561,  19.60649804197948
2, 18.60047721773811,  76.30952296348833
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
