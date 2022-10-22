***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 9.98704920119481 , 13.0
3, 8.64289291822936 , 129.831639615532530
2, 3.13245224289365 , -6.49058837208138
2, 2.80830154660878 , -7.94243834626604
4,
2, 11.69433887296928,  454.58995493256509
4, 10.54531145092868,  2.83288985243446
2, 2.08560672214373 , -1.41662992795512
2, 2.68695191535280 , 12.72693766817297
4,
2, 9.11992339356297 , 292.69390207484844
4, 8.55246891393972 , 11.09441552076021
2, 2.82094133859438 , -0.86303147203935
2, 2.78906107375250 , 12.58436755652044
4,
2, 5.50422823128628 , 115.65207303698706
4, 5.81006383435716 , 1.23697926737036
2, 1.30439594894798 , -1.21475717973501
2, 2.72146750178988 , 12.78475271219527
2,
2, 1.96027964349017 , 13.45318571949514
2, 3.04663955217115 , 12.93349533782910
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


Ta_ccsd=-57.48001992
O_ccsd=-15.86622096

!These are the wf cards parameters
ne = 19
symm = 1
ss= 1

!There are irrep cards paramters
A1=5
B1=2
B2=2
A2=1


geometry={
    2
    TaH molecule
    Ta 0.0 0.0 0.0
    O 0.0 0.0 1.70
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-1,B1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Ta_ccsd-O_ccsd


table,1.70,scf,ccsd,bind
save
type,csv

