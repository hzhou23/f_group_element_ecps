***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


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
2, 3.90182599315564 , 12.9123812587086
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Ta_ccsd=-57.27626880
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 14
symm = 1
ss= 4

!There are irrep cards paramters
A1=4
B1=2
B2=2
A2=1


geometry={
    2
    TaH molecule
    Ta 0.0 0.0 0.0
    H 0.0 0.0 1.20
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-1,B1-1,B2-1,A2-1
 sym,1,1,1,1,2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Ta_ccsd-H_ccsd


table,1.20,scf,ccsd,bind
save
type,csv

