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
1, 14.31072789686652,  18.0
3, 13.41499992939446,  257.593102143597360
2, 6.61488003615126 , -72.98451539488113
2, 3.47225526412711 , -12.19538760989574
2
2, 5.45107784458823 , 175.39000371848385
2, 3.99424772802846 , 28.72349612208301
2
2, 4.40102281125295 , 144.28575890774033
2, 13.17179534917863,  20.41695702522835
2
2, 5.70808151795889 , 102.11440925862388
2, 1.99519187895450 , 20.10804270215242
2
2, 15.52700821801197,  20.13302617025831
2, 15.17021194632848,  76.82938255007139
include,../generate/aug-cc-pwCVTZ_ecp.basis
}



include,../generate/Gd_states_ae.proc

do i=NUM,NUM
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
