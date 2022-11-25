***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 8.39598440028374 , 13.0
3, 7.37204634037326 , 109.147797203688620
2, 3.59426461550466 , -6.97762620302664
2, 2.53651534553904 , -9.08990100107218
4
2, 15.77409349159417,  354.34497668308012
4, 4.73150925136044 , -3.36288328567609
2, 6.42244768583840 , 14.71521080287564
2, 2.33015388516164 , 13.55888264193246
4
2, 7.33302182314337 , 292.77153596295352
4, 6.95329946658371 , -10.22941188986537
2, 4.81105117755140 , 5.35612772062824
2, 5.10282744958003 , 9.36569686262789
4
2, 4.74648862402405 , 115.85668922106750
4, 6.57684845168785 , -0.64292833091888
2, 9.87506717885305 , 5.36998053855476
2, 6.28668151258437 , 12.55041997401365
2
2, 1.80239673715769 , 13.58753286356772
2, 3.31611656282064 , 12.94363458831643
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Ta_ccsd=-56.79346473
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
    H 0.0 0.0 2.00
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


table,2.00,scf,ccsd,bind
save
type,csv

