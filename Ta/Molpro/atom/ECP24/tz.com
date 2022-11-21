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
1, 11.59955603801382,  13.0
3, 10.28878382727161,  150.794228494179660
2, 7.56839971518148 , -5.16403225888320
2, 1.06720991445458 , -0.14402832208558
2
2, 13.91077612770670,  459.65978721826127
2, 3.63099164341881 , 12.15957777083788
2
2, 10.74047351732486,  378.26642724289638
2, 4.27043588911270 , 17.15718598504107
2
2, 6.04757079405806 , 109.95508182840369
2, 5.62563494478422 , 28.61095965996630
2
2, 6.81575581880497 , 11.99734953847806
2, 1.89725263128968 , 11.85190830922786
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
