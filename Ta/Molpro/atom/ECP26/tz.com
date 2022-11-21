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
1, 11.52668847907439,  13.0
3, 10.23582774434061,  149.846950227967070
2, 7.69152913201334 , -5.08410948336542
2, 1.19909855386176 , -0.27206409777687
2
2, 13.78006217876381,  459.66374912843781
2, 3.76171626793589 , 12.36850328871579
2
2, 10.56223960944087,  378.27274614187178
2, 4.31318240864939 , 17.22758959371997
2
2, 6.09214140703617 , 109.95861638335317
2, 5.36402460996997 , 28.62454507299603
2
2, 6.81494428131636 , 11.99066668621293
2, 1.74852611534671 , 11.86085394407344
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
