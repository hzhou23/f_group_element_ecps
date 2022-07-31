***,atomic
memory,1,g

gthresh,twoint=1.e-15
gthresh,oneint=1.e-15

angstrom
geometry={
1

Tb  0.0 0.0 0.0
}

basis={
include,/global/homes/a/aannabe/docs/Tb_project/ccECP/basis_sets/Tb_aug-cc-pwCVTZ.basis
}

set,dkroll=1,dkho=99,dkhp=2

include, states.proc

do i=2,2
   if (i.eq.1) then
      GS_5s2_5p6_6s2_4f9
   else if (i.eq.2) then
      EX_5s2_5p6_6s2_4f8_5d1
   else if (i.eq.3) then
      EX_5s2_5p6_6s1_4f8_5d2
   else if (i.eq.4) then
      EX_5s2_5p6_6s2_4f8_6p1
   else if (i.eq.5) then
      IP1_5s2_5p6_6s1_4f9
   else if (i.eq.6) then
      IP1_5s2_5p6_6s1_4f8_5d
   else if (i.eq.7) then
      IP1_5s2_5p6_6s2_4f8
   else if (i.eq.8) then
      IP2_5s2_5p6_4f9
   else if (i.eq.9) then
      IP2_5s2_5p6_4f8_5d1
   else if (i.eq.10) then
      IP2_5s2_5p6_6s1_4f8
   else if (i.eq.11) then
      IP3_5s2_5p6_4f8
   else if (i.eq.12) then
      IP3_5s2_5p6_4f7_5d1
   else if (i.eq.13) then
      IP3_5s2_5p6_6s1_4f7
   else if (i.eq.14) then
      IP4_5s2_5p6_4f7
   else if (i.eq.15) then
      IP7_5s2_5p3_4f7
   end if
   scf(i)=energy
   pop
   _CC_NORM_MAX=2.0
   {uccsd(t),shifts=0.2,shiftp=0.2,thrdis=1.0;diis,1,1,15,1;maxit,100;core;
   THRESH,ENERGY=5.e-6,COEFF=1e-3
   }
   ccsd(i)=energy
enddo

table,scf,ccsd
save, 3.csv, new

