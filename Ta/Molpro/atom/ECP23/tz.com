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
1, 11.59758991568435,  13.0
3, 10.31204704664821,  150.768668903896550
2, 7.56395736661440 , -5.16599826097209
2, 1.03796969604685 , -0.24366619971744
2
2, 13.95946715183546,  459.65971617318951
2, 3.65749272304418 , 12.15562157626328
2
2, 10.79480910249927,  378.26604750886395
2, 4.35406113378858 , 17.14922657499741
2
2, 6.02285454561391 , 109.95544669641397
2, 5.61708486770160 , 28.61143397742792
2
2, 6.81576146474346 , 11.99734876058946
2, 1.89849343698004 , 11.85184136154177
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
