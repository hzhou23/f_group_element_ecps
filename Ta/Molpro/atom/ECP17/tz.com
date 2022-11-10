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
5
2, 3.04033,-5.8644665 
1, 9.47542488781723, 6.5 
3, 6.69638523920446, 61.59026177081199 
2, 4.49665188987648, -2.372786470856735 
2, 5.30234697006755, -3.75516623454264 
7
2, 14.546408,672.9403235 
2, 7.27320,18.383403 
2, 3.04033,5.8644665 
2, 12.98757659063021,127.22065886304347 
4, 5.17648717888461,1.57788635160478 
2, 2.46430257337332,-1.485542436557125 
2, 4.38156727576169,7.106505246181465 
7
2, 9.935565,189.2126505 
2, 4.967782,11.1465455 
2, 3.04033,5.8644665 
2, 10.85433613775534,146.40174933209408 
4, 8.95319690470203,5.538702888867905 
2, 5.04773343191292,-1.002635271276915 
2, 5.34475616661697,6.049810039677395 
7
2, 6.347377,52.441978 
2, 3.173688,4.377924 
2, 3.04033,5.8644665 
2, 7.40231078774127,57.7663171914661 
4, 5.88160011745925,0.637812224559 
2, 1.6493058366644,0.039419405319645 
2, 4.62279215188138,6.201535046789115 
4
2, 2.017881,6.0089805 
2, 3.04033,5.8644665 
2, 4.26309031604805,6.72973054804929 
2, 2.18866111514022,6.50649824549528
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
        EAd5s1
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
