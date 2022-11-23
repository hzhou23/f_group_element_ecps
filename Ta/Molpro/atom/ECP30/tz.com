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
1, 11.59776397189709,  13.0
3, 10.30993554746943,  150.770931634662170
2, 7.56435036926696 , -5.16579651360517
2, 1.06078011952243 , -0.25301141831400
2
2, 13.92143967707804,  459.65971069859705
2, 3.65155183768487 , 12.15519028726016
2
2, 10.78514016520376,  378.26612169656181
2, 4.34686040199295 , 17.15016968681727
2
2, 6.03276113025771 , 109.95530480235156
2, 5.62024493515877 , 28.61125948107140
2
2, 6.81575376235230 , 11.99734986096493
2, 1.89682361594309 , 11.85193143502216
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
