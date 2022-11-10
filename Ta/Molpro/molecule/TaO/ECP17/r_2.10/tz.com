***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
5
2, 3.04033,-5.8644665
1, 9.47542488781723, 6.5
3, 6.69638523920446, 61.59026177081199
2, 4.49665188987648, -2.372786470856735
2, 5.30234697006755, -3.75516623454264
7
2, 14.546408,672.9403235
2, 7.27320,18.383403
2, 3.04033,5.8644665
2, 12.98757659063021,127.22065886304347
4, 5.17648717888461,1.57788635160478
2, 2.46430257337332,-1.485542436557125
2, 4.38156727576169,7.106505246181465
7
2, 9.935565,189.2126505
2, 4.967782,11.1465455
2, 3.04033,5.8644665
2, 10.85433613775534,146.40174933209408
4, 8.95319690470203,5.538702888867905
2, 5.04773343191292,-1.002635271276915
2, 5.34475616661697,6.049810039677395
7
2, 6.347377,52.441978
2, 3.173688,4.377924
2, 3.04033,5.8644665
2, 7.40231078774127,57.7663171914661
4, 5.88160011745925,0.637812224559
2, 1.6493058366644,0.039419405319645
2, 4.62279215188138,6.201535046789115
4
2, 2.017881,6.0089805
2, 3.04033,5.8644665
2, 4.26309031604805,6.72973054804929
2, 2.18866111514022,6.50649824549528
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


Ta_ccsd=-56.91258854
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
    O 0.0 0.0 2.10
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


table,2.10,scf,ccsd,bind
save
type,csv

