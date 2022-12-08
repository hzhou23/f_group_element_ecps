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
1, 6.58579803212618 , 13.0
3, 9.13192842576420 , 85.615374417640340
2, 7.99186085237527 , -0.26293749961227
2, 1.84263860654940 , -2.27391351331509
4
2, 16.08487737880344,  354.40078018080508
4, 4.85668884301541 , -3.10906211229170
2, 6.30802922975839 , 15.27406034238401
2, 4.04911757928159 , 17.76189033024011
4
2, 9.21923589281251 , 291.70871884263369
4, 8.30422516651248 , -10.54318109647359
2, 3.16045125855980 , -0.60632678182044
2, 2.27620720575355 , 3.70756033781846
4
2, 5.66393146919502 , 119.43407155054338
4, 6.80490694652875 , -1.42875323933968
2, 5.86746551190718 , 6.08463244531056
2, 5.45850446761400 , 14.58929295482653
2
2, 1.88569677412283 , 13.74156012098197
2, 3.23123426818858 , 12.96703882608918
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
