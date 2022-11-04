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
1, 8.77790117627654 , 13.0
3, 6.48149180155711 , 114.112715291595020
2, 1.19085397255519 , -2.04898002197270
2, 7.92583251619790 , -3.21619546558884
4
2, 16.13993175162957,  254.01928334447388
4, 2.93128262881855 , 3.81550524440964
2, 1.70738984621322 , 0.67282061733050
2, 3.58612911311473 , 8.00492701798377
4
2, 8.14311755601626 , 293.05690801485002
4, 6.74560826496179 , 11.22141465551174
2, 4.60658981856390 , -2.25732484440155
2, 7.96664053782118 , 17.52882639123408
4
2, 9.30298627335207 , 114.67213803326901
4, 1.56979026745126 , 1.48997099574140
2, 1.57389889274898 , 2.12000267087927
2, 3.50380794298312 , 9.29197330028284
2
2, 6.90787427695400 , 13.37652354013105
2, 1.67272692693566 , 13.12049063791291
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
