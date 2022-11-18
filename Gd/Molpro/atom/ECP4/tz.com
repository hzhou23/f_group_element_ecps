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
1, 4.37165210248423,  18.0
3, 4.18709104507094,  78.689737844716140
2, 5.02727409587413,  -85.71236883444210
2, 1.62237745015724,  -3.30112475404507
2
2, 8.91523076289608,  161.12062978419820
2, 4.84280458817852,  89.34030645883358
2
2, 7.10951184042807,  88.71053979964422
2, 3.68628041297993,  57.16614279450840
2
2, 7.60169339914943,  55.89579459544814
2, 2.25372397458399,  29.33187329444837
2
2, 4.62944405114349,  -23.99230415876960
2, 3.78978252487005,  -7.13305721447725
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
