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
1, 4.56840872207060 , 18.0
3, 4.28972942009220 , 82.231356997270800
2, 5.40412492957167 , -90.06462174212133
2, 3.05884267585660 , -6.15603892082516
2
2, 11.91348441639771,  159.60898489054014
2, 4.71382665168407 , 81.24887611836824
2
2, 9.77061655240615 , 88.56372836956160
2, 3.59839607293592 , 50.53844947585181
2
2, 9.25403456535037 , 55.14223366433400
2, 2.45839008714535 , 30.93671185887393
2
2, 3.41028173602588 , -21.67494644734868
2, 2.91368931251914 , -2.29372246802204
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
