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
1 4.32698972    18.0
3 4.30465235    77.88581504279703
2 5.66712002    -91.64904501
2 3.16146066    -9.50818118
2
2 11.95874295  159.68544977
2  4.57502029  75.07118987
2
2  9.32702741  86.79062655
2  3.72730927  56.76194112
2
2  9.14239802  55.1796938 
2  2.41026285  28.91969228
2
2  3.49609108  -22.94954207
2  6.1622991   -2.26373977
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