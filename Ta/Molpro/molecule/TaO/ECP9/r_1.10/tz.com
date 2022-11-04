***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 9.49594023190898 , 13.0
3, 6.50213664288903 , 123.447223014816740
2, 4.55207617239207 , -4.73322703998514
2, 5.34492732203557 , -7.50464766318908
4
2, 13.07454881136209,  254.44003651814958
4, 5.18791160933069 , 3.14821025129681
2, 2.36469078852815 , -3.03647119047403
2, 4.52758904935943 , 14.18948675412584
4
2, 10.66539913093377,  292.80520935255618
4, 8.94566364427656 , 11.07885341780337
2, 5.07244378444537 , -1.98312762653506
2, 5.20852558990916 , 12.11985258818453
4
2, 7.34000171030301 , 115.53367911512949
4, 5.88034631027534 , 1.27689567773619
2, 1.63616622242908 , 0.15509416503100
2, 4.57636420762624 , 12.40846350156638
2
2, 4.26286799231895 , 13.45947945379355
2, 2.18505109857281 , 13.01318709804272
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


Ta_ccsd=-56.76676756
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
    O 0.0 0.0 1.10
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


table,1.10,scf,ccsd,bind
save
type,csv

