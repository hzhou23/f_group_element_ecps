***,Calculation for Nb atom, singlet and triplet
memory,1,g
geometry={
1
Nb
Nb  0.0 0.0 0.0
}

gthresh,twoint=1.0E-15
gthresh,oneint=1.0E-15


basis={
ECP,Nb,28,4,0
4
1, 19.86089158295794,  13.0
3, 19.52592677324002,  258.191590578453220
2, 7.38820086785453 , -23.26312802426079
2, 4.55864105458634 , -4.88737492545031
2
2, 8.45144984331345 , 188.14727662154681
2, 4.65585389203211 , 25.67388126105923
2
2, 8.19202422427608 , 134.29806965607142
2, 3.46626252816859 , 17.38155611740850
2
2, 6.82507161050075 , 60.15121909620855
2, 2.85815732720811 , 10.39336936151948
include,aug-cc-pwCVTZ.basis
}

include,../generate/Nb_states_ecp.proc

do i=1,1
    if (i.eq.1) then
        Id4s1
    else if (i.eq.2) then
        Id5
    else if (i.eq.3) then
        EAd4s2
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
        IVp1
    else if (i.eq.10) then
        IVf1
    else if (i.eq.11) then
        Vp6
    else if (i.eq.12) then
        VIp5
    else if (i.eq.13) then
        VIIp4
    else if (i.eq.14) then
        VIIIp3
    else if (i.eq.15) then
        IXp2
    else if (i.eq.16) then
        Xp1
    else if (i.eq.17) then
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
