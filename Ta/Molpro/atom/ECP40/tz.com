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
1, 8.15167071214843 , 13.0
3, 7.47331151473489 , 105.971719257929590
2, 3.60056980031168 , -4.33990921902682
2, 2.22768591908541 , -5.48237767142245
4
2, 14.26146863392103,  354.70559893032032
4, 3.46380088536042 , -4.66433522275690
2, 7.67473828213120 , 14.96277845276818
2, 3.32617448921098 , 18.06587123731066
4
2, 8.82776046180438 , 291.64570470842796
4, 10.92675385586350,  -10.33282235036178
2, 1.07888491208704 , -1.48633153391591
2, 1.59607283234255 , 5.32388963790117
4
2, 5.16943902590341 , 119.16168907061243
4, 8.37942821085845 , -6.56765578099286
2, 8.40135332277504 , 5.35348311861657
2, 5.26312970451924 , 14.27305237521244
2
2, 1.77611393718485 , 13.56453418078870
2, 3.90182599315564 , 12.91238125870868
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
