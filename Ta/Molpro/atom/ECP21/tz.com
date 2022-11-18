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
1, 11.88350471855019,  13.0
3, 10.97377991301274,  154.485561341152470
2, 2.01971647266911 , -1.13189017422195
2, 2.69767939922724 , -1.45042145161090
2
2, 16.54628001682965,  459.65608518058320
2, 3.87872556430454 , 24.60162382163432
2
2, 11.22461418294209,  378.65585022268527
2, 4.14425727614165 , 26.75998268495469
2
2, 5.96253273825446 , 106.73173866394947
2, 4.42656456365080 , 23.03770926634766
2
2, 2.87921258907750 , 12.36300003963198
2, 1.86942107458829 , 12.21690623386405
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
