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
1, 6.22277547622137 , 13.0
3, 9.46199566781226 , 80.896081190877810
2, 10.00000000000000,  -0.01187830995750
2, 1.51182272154401 , -1.35101140330964
4
2, 16.56930101377441,  354.55483305068651
4, 5.49009104528294 , -2.44698885633796
2, 6.33388517706123 , 15.91973790594979
2, 4.29260816407439 , 17.51036994772198
4
2, 9.70661784719624 , 291.17021528555273
4, 9.20736952888341 , -10.80861552745203
2, 3.20730360963005 , -1.85816524133517
2, 2.20803594203658 , 4.32533814066039
4
2, 5.88366641855202 , 120.57408652791342
4, 6.20647508214972 , -3.30337622290122
2, 5.80940115627031 , 6.43089775145994
2, 5.15165266139958 , 15.81868406718569
2
2, 1.88800902687763 , 13.75856785152156
2, 3.80730354125196 , 12.93477243719946
include,../generate/aug-cc-pwCVTZ.basis
}



include,../generate/Ta_states_ae.proc


do i=1,13
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
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
