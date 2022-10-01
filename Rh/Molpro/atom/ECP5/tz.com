***,Calculation for Rh atom, singlet and triplet
memory,1,g
geometry={
1
Rh
Rh  0.0 0.0 0.0
}

gthresh,twoint=1.0E-15
gthresh,oneint=1.0E-15


basis={
ECP, rh, 28, 3
4
1, 22.80620553159304,  17.0
3, 32.71000635592747,  387.705494037081680
2, 14.04858672478363,  -10.57196656168149
2, 11.83833524886781,  -14.59446052899020
2
2, 11.96851556026113,  245.38791874527365
2, 5.12576018874406 , 27.28583987118665
2
2, 9.73960036628028 , 180.58942316852949
2, 6.56477618290695 , 28.41162810130719
2
2, 11.42592077796438,  83.48704442041299
2, 4.50252107517308 , 21.38037165422960
include,../generate/Rh-aug-cc-pwCVTZ.basis
}

include,../generate/Rh_states_ecp.proc

do i=1,16
    if (i.eq.1) then
        Id8s1
    else if (i.eq.2) then
        Id8p1
    else if (i.eq.3) then
        Id9
    else if (i.eq.4) then
        EAd8s2
    else if (i.eq.5) then
        IPd8
    else if (i.eq.6) then
        IPd7s1
    else if (i.eq.7) then
        IId7
    else if (i.eq.8) then
        IIId6
    else if (i.eq.9) then
        IIId5p1
    else if (i.eq.10) then
        IVd5
    else if (i.eq.11) then
        Vd4
    else if (i.eq.12) then
        VId3
    else if (i.eq.13) then
        VIId2
    else if (i.eq.14) then
        VIIId1
    else if (i.eq.15) then
        IXp6
    else if (i.eq.16) then
        Xp3
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),shifts=0.2,shiftp=0.2,thrdis=1.0;diis,1,1,15,1;maxit,100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
