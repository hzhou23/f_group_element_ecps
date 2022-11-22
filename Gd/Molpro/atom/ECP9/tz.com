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
1, 4.86112545927015,  18.0
3, 4.58053883332205,  87.500258266862700
2, 5.78814290224213,  -93.12753299849874
2, 2.81612934656671,  -6.08789998084934
2
2, 9.81540452403689,  160.00482230021498
2, 4.72397174194007,  82.33215011422709
2
2, 8.44347433126580,  88.49557961199658
2, 3.50384652351382,  53.44862038202471
2
2, 9.89814890486055,  55.34505150098937
2, 2.29200965822275,  29.30985705124326
2
2, 4.04550121056815,  -26.81163578092148
2, 5.41504278418701,  -3.51118686828206
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
