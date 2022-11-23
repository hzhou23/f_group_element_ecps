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
1, 11.59846713318753,  13.0
3, 10.30138310915892,  150.780072731437890
2, 7.56606428986412 , -5.16510429265123
2, 1.06079938137337 , -0.21441363222078
2
2, 13.93075460859432,  459.65969585668159
2, 3.66145249291283 , 12.15492338265921
2
2, 10.74802166865865,  378.26637823644387
2, 4.28678053197190 , 17.15580752348776
2
2, 6.06201023520961 , 109.95486191028429
2, 5.63071851403519 , 28.61067723258784
2
2, 6.81574909818723 , 11.99735065848355
2, 1.89577196105710 , 11.85198800725011
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
