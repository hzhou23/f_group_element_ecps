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
1, 11.59763423890102,  13.0
3, 10.30444085772715,  150.769245105713260
2, 7.56795623574980 , -5.16562234368678
2, 1.08220514721343 , -0.05030543795228
2
2, 14.11289368233007,  459.65843738089995
2, 4.07780952468083 , 12.09212043206165
2
2, 10.35384120993022,  378.26914249441927
2, 3.70023088350270 , 17.21240663198371
2
2, 6.23202842783333 , 109.95231294585955
2, 5.68813123054174 , 28.60741169751503
2
2, 6.81562599913156 , 11.99736963128376
2, 1.86852465388835 , 11.85345672027205
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
