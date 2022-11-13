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
1, 14.03217415590809,  15.0
3, 12.37878195601535,  210.482612338621350
2, 4.13510464844168 , -8.84227144600072
2, 3.32656587417719 , -8.41797057785723
2
2, 12.09720505731674,  471.25549653152109
2, 3.36420226655362 , 18.43943606828873
2
2, 8.24983980371847 , 265.54731080786206
2, 5.76133450333200 , 50.64532212102785
2
2, 6.51515042648658 , 108.54017285087255
2, 3.80366747583870 , 30.60482037829906
2
2, 2.21123580029442 , 16.96598486353070
2, 4.06855790790147 , 17.85940061266256
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
