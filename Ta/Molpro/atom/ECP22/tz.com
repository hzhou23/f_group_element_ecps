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
1, 11.49359525482568,  13.0
3, 10.13913654925267,  149.416738312733840
2, 7.97511520789609 , -6.03406515016282
2, 1.01000000000000 , -0.31110729601449
2
2, 14.14612656777027,  459.59879457929856
2, 3.72713175663791 , 12.91274471332207
2
2, 10.89406043961893,  378.24994749881557
2, 4.33871457615221 , 16.98507934717156
2
2, 6.09113600764388 , 110.00602740934724
2, 5.49852442672511 , 28.47691799768191
2
2, 6.76042007200464 , 12.00239531058859
2, 1.89414073170908 , 11.84039532655034
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
