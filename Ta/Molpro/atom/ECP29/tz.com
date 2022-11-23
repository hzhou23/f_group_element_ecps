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
1, 11.59761841744373,  13.0
3, 10.31134182538065,  150.769039426768490
2, 7.56422826774257 , -5.16594232496994
2, 1.06079303145070 , -0.23768823490065
2
2, 13.92943810112238,  459.65964810634023
2, 3.67787769377198 , 12.15245079728659
2
2, 10.74684591827618,  378.26621818108237
2, 4.32431147960501 , 17.15228424017296
2
2, 6.03446720667145 , 109.95527664454291
2, 5.62094544802257 , 28.61121908058095
2
2, 6.81575128561277 , 11.99735029498906
2, 1.89625271442792 , 11.85196212882447
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
