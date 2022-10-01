***,Calculation for Rh atom, singlet and triplet
memory,1,g
geometry={
1
Rh
Rh  0.0 0.0 0.0
}

gthresh,twoint=1.0E-15
gthresh,oneint=1.0E-15


basis={
ECP, rh, 28, 3
4
1, 24.39418339667943,  17.0
3, 22.04039328647782,  414.701117743550310
2, 8.68959802091859 , -11.28596716898800
2, 9.42876174408168 , -13.65967314795482
2
2, 12.14222075163778,  246.88885026177641
2, 5.27587258937924 , 32.47728600373158
2
2, 9.30893198370713 , 181.20541890285168
2, 7.08173403078745 , 29.20305213092277
2
2, 9.04660426307257 , 83.08287561534985
2, 3.77483713896007 , 10.89084468142145
include,../generate/Rh-aug-cc-pwCVTZ.basis
}

include,../generate/Rh_states_ecp.proc

do i=1,16
    if (i.eq.1) then
        Id8s1
    else if (i.eq.2) then
        Id8p1
    else if (i.eq.3) then
        Id9
    else if (i.eq.4) then
        EAd8s2
    else if (i.eq.5) then
        IPd8
    else if (i.eq.6) then
        IPd7s1
    else if (i.eq.7) then
        IId7
    else if (i.eq.8) then
        IIId6
    else if (i.eq.9) then
        IIId5p1
    else if (i.eq.10) then
        IVd5
    else if (i.eq.11) then
        Vd4
    else if (i.eq.12) then
        VId3
    else if (i.eq.13) then
        VIId2
    else if (i.eq.14) then
        VIIId1
    else if (i.eq.15) then
        IXp6
    else if (i.eq.16) then
        Xp3
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),shifts=0.2,shiftp=0.2,thrdis=1.0;diis,1,1,15,1;maxit,100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
