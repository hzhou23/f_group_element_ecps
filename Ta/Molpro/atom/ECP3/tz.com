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
1, 4.97457193632958 , 13.0
3, 5.26023418565353 , 64.669435172284540
2, 2.67197983462605 , -0.47605524943075
2, 2.15817910240543 , -4.21351817610039
4
2, 20.70286031354501,  454.96025660560673
4, 10.02973048304008,  3.47878476450205
2, 3.10272962118842 , -4.19305106472309
2, 6.04457196856476 , 32.58466298556971
4
2, 14.07770029821275,  335.32382043610954
4, 10.67841170611441,  9.55688761498871
2, 7.27226289027606 , -1.06597356003652
2, 3.35050503471790 , 6.21526515818441
4
2, 6.59468869849815 , 110.63182769382087
4, 3.33717093287225 , 3.06285056177862
2, 2.21211584635493 , -3.00775400813279
2, 3.90532938257064 , 15.88040149700235
2
2, 4.91710833772849 , 12.91431890903127
2, 1.93006873288129 , 12.79554014975909
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
