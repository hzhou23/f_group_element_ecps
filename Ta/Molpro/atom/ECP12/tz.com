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
1, 9.48354984728286 , 13.0
3, 6.58352058799641 , 123.286148014677180
2, 4.53783404281474 , -4.73845979672182
2, 5.33153203848401 , -7.50802898990991
4
2, 13.08064517176842,  254.43995214267545
4, 5.18927021220074 , 3.14747350512849
2, 2.34836222469719 , -3.04417162277243
2, 4.54319242921459 , 14.18738115318655
4
2, 10.68386290108032,  292.80504159008149
4, 8.93610336093008 , 11.07871486911938
2, 5.06997807719390 , -1.98530110445075
2, 5.22228575611653 , 12.11784102031758
4
2, 7.34230942457809 , 115.53364060236790
4, 5.88039254978989 , 1.27684366101383
2, 1.63670333180241 , 0.15227366454565
2, 4.57809381301482 , 12.40826301987227
2
2, 4.26284286092039 , 13.45948149401937
2, 2.18464493417286 , 13.01320856385272
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
