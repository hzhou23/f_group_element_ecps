***,Calculation for Ta atom, singlet and triplet
memory,1,g

gthresh,twoint=1.e-15
gthresh,oneint=1.e-15


geometry={
1
Ta
Ta  0.0 0.0 0.0
}

basis={
ECP, ta, 60, 4 ;
4
1, 9.96102142251623 , 13.0
3, 8.66753180821403 , 129.493278492710990
2, 3.18293734710823 , -6.44289441991725
2, 3.37444446594210 , -7.85803706449262
4
2, 11.76280919071458,  454.58924740165031
4, 10.54478300852329,  2.83798725639408
2, 2.20845245478701 , -1.27159179030538
2, 3.04787065946180 , 12.78948851428200
4
2, 9.16823157907189 , 292.69323167970038
4, 8.55157810162544 , 11.09449423855064
2, 2.84461656319272 , -0.82798881088714
2, 3.11834655778119 , 12.56777196647712
4
2, 5.40674277680677 , 115.65450592465247
4, 5.81188044539469 , 1.23403492783475
2, 1.38012716297445 , -1.28569069037775
2, 3.16698480959398 , 12.76813670988949
2
2, 2.05979276202828 , 13.46298142736888
2, 2.88241373632644 , 12.94572104718611
include,../generate/aug-cc-pwCVTZ.basis
}



include,../generate/Ta_states_ae.proc


do i=1,16
    if (i.eq.1) then
        Id3s2
    else if (i.eq.2) then
        Id4s1
    else if (i.eq.3) then
        EAd5s1
    else if (i.eq.4) then
        IPd4
    else if (i.eq.5) then
        IPd3s1
    else if (i.eq.6) then
        IId3
    else if (i.eq.7) then
        IIId2
    else if (i.eq.8) then
        IVd1
    else if (i.eq.9) then
        IVf1
    else if (i.eq.10) then
        IVs1
    else if (i.eq.11) then
        IVp1
    else if (i.eq.12) then
        Vp6
    else if (i.eq.13) then
        VIIp4
    else if (i.eq.14) then
        VIIIp3
    else if (i.eq.15) then
        IXp2
    else if (i.eq.16) then
        XIp
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
