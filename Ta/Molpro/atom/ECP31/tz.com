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
1, 11.54542663317389,  13.0
3, 10.30073261824193,  150.090546231260570
2, 7.44122477816325 , -4.75547879605754
2, 1.01000000000000 , -0.36784358206389
2
2, 13.27097900765338,  459.64894585291336
2, 4.28810379263681 , 14.84059619006059
2
2, 10.32025737794254,  378.18958213046579
2, 4.66669588906523 , 17.72039482261934
2
2, 5.99475553906152 , 109.80138980771386
2, 5.28003453413524 , 28.29124994000736
2
2, 6.79748662433368 , 12.00018406415729
2, 1.71067113262195 , 11.90750585693222
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
