***,Calculation for Gd atom, singlet and triplet
memory,1,g

gthresh,twoint=1.e-15
gthresh,oneint=1.e-15


geometry={
1
Gd
Gd  0.0 0.0 0.0
}

basis={
ECP, Gd, 46, 4 ;
4
1, 14.29709227976785,  18.0
3, 13.64678250050948,  257.347661035821300
2, 6.45168785577027 , -73.01589770309202
2, 3.90710545171246 , -12.21833509889686
2
2, 5.51081567527800 , 175.38948057909647
2, 4.00517145354705 , 28.72189578013280
2
2, 4.46277249913341 , 144.28482885808378
2, 13.17222685203656,  20.41694294609965
2
2, 5.33052058648193 , 102.12134921220922
2, 2.16598720744052 , 20.13409933935873
2
2, 15.55569177122116,  20.12421615067083
2, 15.28841360474289,  76.81958524414689
include,../generate/aug-cc-pwCVTZ_ecp.basis
}



include,../generate/Gd_states_ae.proc

do i=1,12
    if (i.eq.1) then
        Id1f7s2
    else if (i.eq.2) then
        Id2f7s1
    else if (i.eq.3) then
        Ip1f7s2
    else if (i.eq.4) then
        EAd2f7s2
    else if (i.eq.5) then
        IId1f7s1
    else if (i.eq.6) then
        IIdf7s2
    else if (i.eq.7) then
        IIId1f7
    else if (i.eq.8) then
        IIIp1f7
    else if (i.eq.9) then
        IVdf7
    else if (i.eq.10) then
        Vdf6
    else if (i.eq.11) then
        VIdf5
    else if (i.eq.12) then
        VIIdf4
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
