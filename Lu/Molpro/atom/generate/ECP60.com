***,Calculation for Lu atom, singlet and triplet
memory,1,g

gthresh,twoint=1.e-15
gthresh,oneint=1.e-15


geometry={
1
Lu
Lu  0.0 0.0 0.0
}

basis={
ECP, Lu, 60, 4 ;
4
1, 6.58579803212618 , 11.0
3, 9.13192842576420 , 72.44377835338798
2, 7.99186085237527 , -0.26293749961227
2, 1.84263860654940 , -2.27391351331509
4
2, 16.08487737880344,  354.56078018080508
4, 4.85668884301541 , -3.18906211229170
2, 6.30802922975839 , 15.43406034238401
2, 4.04911757928159 , 17.92189033024011
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
2, 3.23123426818858 , 12.9670388260891
include,../generate/aug-cc-pwCVTZ.basis
}



include,../generate/Lu60_states_ecp.proc

do i=1,17
    if (i.eq.1) then
        Id1s2
    else if (i.eq.2) then
        Ip1s2
    else if (i.eq.3) then
        IEd2s1
    else if (i.eq.4) then
        IEf1s2
    else if (i.eq.5) then
        IIds2
    else if (i.eq.6) then
        IId1s1
    else if (i.eq.7) then
        IIIds1
    else if (i.eq.8) then
        IIIp1
    else if (i.eq.9) then
        IIId1
    else if (i.eq.10) then
        IIIEf1
    else if (i.eq.11) then
        VIp6
    else if (i.eq.12) then
        VIIp5
    else if (i.eq.13) then
        VIIIp4
    else if (i.eq.14) then
        IXp3
    else if (i.eq.15) then
        Xp
    else if (i.eq.16) then
        XIds2
    else if (i.eq.17) then
        IIIEf2
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
