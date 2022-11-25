***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 8.39889705784972 , 13.0
3, 7.34508858747240 , 109.185661752046360
2, 3.58829902764072 , -6.97440629535382
2, 2.46973293634240 , -9.09022805413226
4
2, 15.78382921365940,  354.34514560888709
4, 4.73299654451634 , -3.36121224192847
2, 6.40866955728764 , 14.71798806693422
2, 2.33777043037359 , 13.56757642346622
4
2, 7.38848525090080 , 292.77116311940819
4, 6.95182698215661 , -10.22964252943435
2, 4.81606144579728 , 5.35461472250129
2, 5.10997585329774 , 9.36442904833929
4
2, 4.76168106390609 , 115.85653524780594
4, 6.57681514153605 , -0.64282943675044
2, 9.87507973033334 , 5.37001991048952
2, 6.28708694756787 , 12.55035672640241
2
2, 1.80139659859822 , 13.58757735947614
2, 3.31603243473976 , 12.9436407443416
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/O-aug-cc-pwCVTZ.basis
}


Ta_ccsd=-57.16308954
O_ccsd=-15.86622096

!These are the wf cards parameters
ne = 19
symm = 1
ss= 3

!There are irrep cards paramters
A1=4
B1=3
B2=3
A2=1


geometry={
    2
    TaH molecule
    Ta 0.0 0.0 0.0
    O 0.0 0.0 1.30
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1,B1-1,B2-1,A2-1
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Ta_ccsd-O_ccsd


table,1.30,scf,ccsd,bind
save
type,csv
