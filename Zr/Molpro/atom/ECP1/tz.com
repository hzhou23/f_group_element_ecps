***,Calculation for Zr atom, singlet and triplet
memory,1,g
geometry={
1
Zr
Zr  0.0 0.0 0.0
}

gthresh,twoint=1.0E-15
gthresh,oneint=1.0E-15


basis={
ECP, zr, 28, 3 
4
1, 17.75345567362377,  12.0
3, 18.60247990486826,  213.041468083485240
2, 6.54774445671811 , -22.42149577885595
2, 3.09551852485908 , -2.73296635340558
2
2, 8.13085529109328 , 171.43015762864633
2, 3.79445846399865 , 21.49748716674211
2
2, 7.12167260382016 , 119.57733314954186
2, 3.30466469125713 , 15.15073604711435
2
2, 5.84687479150679 , 55.95140984121137
2, 2.71977275491985 , 9.53192550206027
include,../generate/Zr-aug-cc-pwCVTZ.basis
}

include,../generate/Zr_states_ecp.proc

do i=1,15
    if (i.eq.1) then
        Id2s2
    else if (i.eq.2) then
        Id3s1
    else if (i.eq.3) then
        EAd3s2
    else if (i.eq.4) then
        IPd2s1
    else if (i.eq.5) then
        IPd3
    else if (i.eq.6) then
        IId2
    else if (i.eq.7) then
        IIId1
    else if (i.eq.8) then
        IIIp1
    else if (i.eq.9) then
        III_f1
    else if (i.eq.10) then
        IVp6
    else if (i.eq.11) then
        VIp4
    else if (i.eq.12) then
        VIIp3
    else if (i.eq.13) then
        VIIIp2
    else if (i.eq.14) then
        IXp1
    else if (i.eq.15) then
        Xp
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),shifts=0.2,shiftp=0.2,thrdis=1.0;diis,1,1,15,1;maxit,100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
