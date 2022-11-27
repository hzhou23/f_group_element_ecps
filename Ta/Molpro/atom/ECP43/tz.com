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
1, 4.32168263241508 , 13.0
3, 6.96176072369861 , 56.181874221396040
2, 10.00000000000000,  -0.28363968806993
2, 2.71233944792430 , -0.13770478278053
4
2, 14.80084774720669,  352.89330944147395
4, 2.52406873850911 , -4.65543489891072
2, 14.38701202502041,  17.02375040569861
2, 8.23921089007605 , 38.72256918634545
4
2, 13.28728103581844,  288.92489558902696
4, 4.22240406580437 , -12.82414956067110
2, 1.01000000000000 , -13.82437002789086
2, 1.27393530013890 , 19.83598894958848
4
2, 7.75535066231043 , 123.15610700857697
4, 10.00000000000000,  -9.48867491291750
2, 1.68473893787203 , 1.18303819815370
2, 9.54008450765152 , 15.42432386524936
2
2, 2.73709268779866 , 13.18536313813843
2, 2.08035364179509 , 13.11515024012137
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
