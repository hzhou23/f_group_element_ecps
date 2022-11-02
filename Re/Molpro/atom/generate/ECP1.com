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
1, 9.98704920119481 , 13.0
3, 8.64289291822936 , 129.831639615532530
2, 3.13245224289365 , -6.49058837208138
2, 2.80830154660878 , -7.94243834626604
4,
2, 11.69433887296928,  454.58995493256509
4, 10.54531145092868,  2.83288985243446
2, 2.08560672214373 , -1.41662992795512
2, 2.68695191535280 , 12.72693766817297
4,
2, 9.11992339356297 , 292.69390207484844
4, 8.55246891393972 , 11.09441552076021
2, 2.82094133859438 , -0.86303147203935
2, 2.78906107375250 , 12.58436755652044
4,
2, 5.50422823128628 , 115.65207303698706
4, 5.81006383435716 , 1.23697926737036
2, 1.30439594894798 , -1.21475717973501
2, 2.72146750178988 , 12.78475271219527
2,
2, 1.96027964349017 , 13.45318571949514
2, 3.04663955217115 , 12.93349533782910
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
