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
1, 9.50469371190010 , 13.0
3, 6.61590413611784 , 123.561018254701300
2, 4.39652254793804 , -4.77828228927443
2, 5.21864441171281 , -7.52933852166620
4
2, 13.00434457471838,  254.44118945678338
4, 5.18153766726856 , 3.15401064425809
2, 2.51237726558707 , -2.95377206562623
2, 4.54220121407984 , 14.19549413518763
4
2, 10.96711744600450,  292.80246543157511
4, 8.95824448859763 , 11.07619649743044
2, 5.03055131398363 , -2.02129426169965
2, 5.41071566975279 , 12.08855391012265
4
2, 7.40722713832715 , 115.53266960652931
4, 5.86793534633668 , 1.27652666602951
2, 1.64786580454618 , 0.01060438065093
2, 4.63630751286395 , 12.40213544658278
2
2, 4.26702074821111 , 13.45912869267590
2, 2.25186234598797 , 13.00964308630563
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
