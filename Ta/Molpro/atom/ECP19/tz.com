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
1, 9.46655013419087 , 13.0
3, 7.78843084106615 , 123.065151744481310
2, 3.47137199178441 , -5.59655218191534
2, 2.49405195038293 , -7.16658050517323
4
2, 10.73850917119655,  454.47974554880477
4, 10.31616070003335,  1.64814946041833
2, 1.82838935641292 , -2.17704894134908
2, 3.25669179803439 , 15.10622653817138
4
2, 10.39108149267816,  292.60910869613969
4, 8.74193475235157 , 11.47905086966635
2, 3.23351118080089 , 3.32125168222668
2, 2.77309403034405 , 10.93341358593607
4
2, 4.91641291764630 , 115.59460798841143
4, 6.24607929603107 , -0.06983595898323
2, 1.06268233531067 , -1.29526382349857
2, 3.05791404429520 , 13.32402975194725
2
2, 1.94078676116682 , 13.56523571304874
2, 2.07362788978169 , 13.02938950706629
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
