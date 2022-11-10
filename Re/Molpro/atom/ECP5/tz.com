***,Calculation for Re atom, singlet and triplet
memory,1,g

gthresh,twoint=1.e-15
gthresh,oneint=1.e-15


geometry={
1
Re
Re  0.0 0.0 0.0
}

basis={
ECP, re, 60, 4 ;
4
1, 10.67500623817997,  15.0
3, 7.85819766729660 , 160.125093572699550
2, 3.36863140426786 , -12.31293775865530
2, 4.17451338014344 , -12.29041899386033
2
2, 11.19308477006133,  349.55585223560087
2, 3.41917553761499 , 14.90976824860685
2
2, 8.66070891213721 , 339.73940989598162
2, 5.79757307586202 , 42.33143667783385
2
2, 6.98790989708612 , 110.41142229825637
2, 3.12000599379110 , 19.87299374014431
2
2, 2.63694647910722 , 16.47403739377819
2, 3.60972449382580 , 16.52458176381737
include,../generate/aug-cc-pwCVTZ.basis
}



include,../generate/Re_states_ae.proc

do i=1,15
    if (i.eq.1) then
        Id5s2
    else if (i.eq.2) then
        Id6s1
    else if (i.eq.3) then
        EAd6s2
    else if (i.eq.4) then
        IPd5s1
    else if (i.eq.5) then
        IPd5p1
    else if (i.eq.6) then
        IId5
    else if (i.eq.7) then
        IIId4
    else if (i.eq.8) then
        IVd3
    else if (i.eq.9) then
        Vd2
    else if (i.eq.10) then
        VId1
    else if (i.eq.11) then
        VIpf1
    else if (i.eq.12) then
        VIp1
    else if (i.eq.13) then
        VIIp6
    else if (i.eq.14) then
        VIIIp4
    else if (i.eq.15) then
        IXp3
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
