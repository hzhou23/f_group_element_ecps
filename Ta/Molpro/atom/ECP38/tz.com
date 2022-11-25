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
1, 8.39839546163777 , 13.0
3, 7.35115489540652 , 109.179141001291010
2, 3.58124428760265 , -6.97580462770369
2, 2.45026266325000 , -9.09318487919907
4
2, 15.76568613335304,  354.34516920116397
4, 4.73325990664599 , -3.36105664802150
2, 6.40762966562004 , 14.71817077051004
2, 2.32637448385383 , 13.56883491973857
4
2, 7.42086531228721 , 292.77094162266002
4, 6.95098684482897 , -10.22978033865548
2, 4.81907971693152 , 5.35369490265210
2, 5.11425064145779 , 9.36367585503029
4
2, 4.75911043201779 , 115.85654187711540
4, 6.57682468475884 , -0.64309821397605
2, 9.87509512090439 , 5.36999835335242
2, 6.28718844510780 , 12.55034798564374
2
2, 1.79845473962337 , 13.58770776362467
2, 3.31578519140372 , 12.94365904773318
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
