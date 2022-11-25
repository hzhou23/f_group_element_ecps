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
1, 8.39598440028374 , 13.0
3, 7.37204634037326 , 109.147797203688620
2, 3.59426461550466 , -6.97762620302664
2, 2.53651534553904 , -9.08990100107218
4
2, 15.77409349159417,  354.34497668308012
4, 4.73150925136044 , -3.36288328567609
2, 6.42244768583840 , 14.71521080287564
2, 2.33015388516164 , 13.55888264193246
4
2, 7.33302182314337 , 292.77153596295352
4, 6.95329946658371 , -10.22941188986537
2, 4.81105117755140 , 5.35612772062824
2, 5.10282744958003 , 9.36569686262789
4
2, 4.74648862402405 , 115.85668922106750
4, 6.57684845168785 , -0.64292833091888
2, 9.87506717885305 , 5.36998053855476
2, 6.28668151258437 , 12.55041997401365
2
2, 1.80239673715769 , 13.58753286356772
2, 3.31611656282064 , 12.94363458831643
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
