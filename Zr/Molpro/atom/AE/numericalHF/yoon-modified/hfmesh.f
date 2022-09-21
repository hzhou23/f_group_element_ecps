	program hartfock

	implicit double precision(a-h,o-z)

	dimension r(2000),dr(2000),r2(2000)
	dimension no(40),nl(40),xnj(40),ev(40),occ(40),is(40)
	dimension ek(40),phe(2000,40),orb(2000,40),njrc(4),vi(2000,9)
	dimension v(2000),q0(2000),xm1(2000),xm2(2000)
	dimension orbo(2000),xqj0(2000),xqj1(2000),xqj2(2000)
	dimension cq(2000),rho(2000,2),vhxc(2000,2)
	dimension iz(32),sigma(0:2,32),ener(8,32),alpha(32)
	dimension sigae(0:2,32),sigvo(0:2,32),elev(0:2,2,32)
	dimension ropen(0:2,2)
        character*4 ichar
	character*4 acd,aca,aci,acq,acw,acr,acu,acff,acf,acg,acs,acm
	data acd,aca,aci,acq,acw,acr/'d','a','i','q','w','r'/
        data acu,acff,acf,acg,acs,acm/'u','F', 'f','g','s','m'/
c
	rel=0.d0
	open(15,file='ip.d',form='formatted',status='unknown')

 10	read (15,20) ichar
 20	format (a1)

	if (ichar.eq.acd) then
	  write (6,*) 'PLEASE ENTER RELATIVITY FACTOR.  (0=NR, 1=REL.)'
	  read (15,*) rel
	endif

	if (ichar.eq.aca) then
	  call abinitio(etot,nst,rel,nr,r,
     1    dr,r2,dl,phe,njrc,vi,zorig,xntot,nel,
     1    no,nl,xnj,ev,occ,is,ek,orb,iuflag)
	endif

	if (ichar.eq.aci) call initiali(zorig,nr,rmin,rmax,
     1	  r,dr,r2,dl,njrc,xntot,nel)

	if (ichar.eq.acq) then
		close(15)
		stop
			  endif

	if (ichar.eq.acw) then
	  ixflag=1
	  call atomwrite(etot,nst,rel,nr,rmin,rmax,zorig,xntot,ixflag,nel,
     1      no,nl,xnj,is,ev,ek,occ,njrc,vi,cq,rho,vhxc,phe,orb,r)
	endif

	if (ichar.eq.acr) then
	  call atomread(etot,nst,rel,nr,rmin,rmax,zorig,xntot,ixflag,nel,
     1      no,nl,xnj,is,ev,ek,occ,njrc,vi,cq,rho,vhxc,phe,orb)
	  call setgrid(nr,rmin,rmax,r,dr,r2,dl)
	endif

	if (ichar.eq.acu) then
	  write (6,*) 'PLEASE ENTER IUFLAG. (0=U, 1=SU, 2=R).'
	  read (15,*) iuflag
	endif

c-------------------------------------------------------------------
	if (ichar.eq.acff) then
c-------------------------------------------------------------------
c  read in all of the data
	open(unit=1,file='ggw.tabdat',status='old')
	open(unit=2,file='trends2.dat',status='old')
	do 1000 i=1,32
	read (1,*) iz(i),sigma(0,i),(ener(j,i), j=1,8)
	read (2,*) idumm,dummy,dummy,dummy,dummy,alpha(i)
	if (dabs(dfloat(iz(i))-zorig).lt.0.01d0) ii=i
 1000	continue
	close(unit=2)
	do 1010 i=1,32
	read (1,*) idumm,sigma(1,i)
 1010	continue
	do 1020 i=1,32
	read (1,*) idumm,sigma(2,i)
 1020	continue
	close(unit=1)
	do 2000 i=nel-2,nel
	ll=nl(i)
	if (ll.eq.0) then
	  sig=sigma(ll,ii)
	  call getrb(nr,r,dr,rb00,phe(1,i),sig,alpha(ii))
	  sig=sigma(ll,ii)+(ener(4,ii)-ener(1,ii))
	  call getrb(nr,r,dr,rb01,phe(1,i),sig,alpha(ii))
	endif
	if (ll.eq.1) then
	  sig=sigma(ll,ii)
	  call getrb(nr,r,dr,rb10,phe(1,i),sig,alpha(ii))
	  esoav=
     1  (dfloat(ll)*ener(5,ii)+dfloat(ll+1)*ener(6,ii))/dfloat(2*ll+1)
	  sig=sigma(ll,ii)+(esoav     -ener(2,ii))
	  call getrb(nr,r,dr,rb11,phe(1,i),sig,alpha(ii))
	  sig=sigma(ll,ii)+(ener(5,ii)-ener(2,ii))
	  call getrb(nr,r,dr,rb12,phe(1,i),sig,alpha(ii))
	  sig=sigma(ll,ii)+(ener(6,ii)-ener(2,ii))
	  call getrb(nr,r,dr,rb13,phe(1,i),sig,alpha(ii))
	endif
	if (ll.eq.2) then
	  sig=sigma(ll,ii)
	  call getrb(nr,r,dr,rb20,phe(1,i),sig,alpha(ii))
	  esoav=
     1  (dfloat(ll)*ener(7,ii)+dfloat(ll+1)*ener(8,ii))/dfloat(2*ll+1)
	  sig=sigma(ll,ii)+(esoav     -ener(3,ii))
	  call getrb(nr,r,dr,rb21,phe(1,i),sig,alpha(ii))
	  sig=sigma(ll,ii)+(ener(7,ii)-ener(3,ii))
	  call getrb(nr,r,dr,rb22,phe(1,i),sig,alpha(ii))
	  sig=sigma(ll,ii)+(ener(8,ii)-ener(3,ii))
	  call getrb(nr,r,dr,rb23,phe(1,i),sig,alpha(ii))
	endif
 2000	continue
	write (6,2222) iz(ii),' & ',alpha(ii),' & ',rb00,' & '
	write (6,2223) rb01,' & ',rb10,' & ',rb11,' & '
	write (6,2223) rb12,' & ',rb13,' & ',rb20,' & '
	write (6,2223) rb21,' & ',rb22,' & ',rb23,' \\'
 2222	format(1x,1i7,1a3,1f15.4,1a3,1f15.4,1a3)
 2223	format(1x,1f15.4,1a3,1f15.4,1a3,1f15.4,1a3)
c-------------------------------------------------------------------
	endif
c-------------------------------------------------------------------

c-------------------------------------------------------------------
	if (ichar.eq.acf) then
c-------------------------------------------------------------------
c  read in all of the data
	open(unit=1,file='open.dat',status='old')
	read (1,*) nentry
	do 3000 i=1,nentry
	read (1,*) iz(i),alpha(i)
	do 2800 l=0,2
	read (1,*) elev(l,1,i),elev(l,2,i),iswitch,param1,param2
	if (iswitch.eq.1) then
	  sigvo(l,i)=param1-elev(l,1,i)
	  sigae(l,i)=param2-elev(l,1,i)
	else
	  sigvo(l,i)=param1
	  sigae(l,i)=param2
	endif
 2800	continue
	if (dabs(dfloat(iz(i))-zorig).lt.0.01d0) ii=i
 3000	continue
	close(unit=1)
	do 4000 i=nel-2,nel
	ll=nl(i)
	sig=sigae(ll,ii)-sigvo(ll,ii)
	call getrb(nr,r,dr,ropen(ll,1),phe(1,i),sig,alpha(ii))
	sig=sig+(elev(ll,2,ii)-elev(ll,1,ii))
	call getrb(nr,r,dr,ropen(ll,2),phe(1,i),sig,alpha(ii))
 4000	continue
	write (6,4222) iz(ii),' & ',alpha(ii),' & '
	do 4100 ll=0,2
	write (6,4223) ropen(ll,1),' & ',ropen(ll,2),' & '
 4100	continue
	write (6,*) ' \\'
 4222	format(1x,1i7,1a3,1f15.4,1a3)
 4223	format(1x,1f15.4,1a3,1f15.4,1a3)
c-------------------------------------------------------------------
	endif
c-------------------------------------------------------------------

c  this was added for working with lmitas's code...

	if (ichar.eq.acg) then
	  njrc(1)=1
	  njrc(2)=1
	  njrc(3)=1
	  njrc(4)=1
	  do 52 i=1,nr
	  call pseudg(r(i),vs,vp,vd,vloc,vloc1)
	  vi(i,1)=vs+vloc
	  vi(i,3)=vp+vloc
	  vi(i,5)=vd+vloc
	  vi(i,7)=vloc
	  vi(i,9)=vloc
	if (r(i).lt.2.)	then
	write (16,*) r(i),vs
	write (17,*) r(i),vp
	write (18,*) r(i),vd
	write (19,*) r(i),vloc1
	write (20,*) r(i),vs+vloc
	write (21,*) r(i),vp+vloc
	write (22,*) r(i),vd+vloc
			endif
 52	  continue
		rcutm=3.
		nmesh=3001
		stmesh=rcutm/float(nmesh-1)
		write(23,*) nmesh
		do j=1,nmesh
		rmesh=stmesh*float(j-1)
		call pseudg(rmesh,vs,vp,vd,vloc,vloc1)
	write (23,*) rmesh,2.*(vs+vloc),2.*(vp+vloc),2.*(vd+vloc),2.*vloc
		enddo
	close(16)
        close(17)
        close(18)
        close(19)
        close(20)
        close(21)
        close(22)
			  endif
c
c	for meshes
c
c        if (ichar.eq.acm) then
c          njrc(1)=1
c          njrc(2)=1
c          njrc(3)=1
c          njrc(4)=1
c          do i=1,nr
c          call pseudm(r(i),vs,vp,vloc)
c          vi(i,1)=vs
c          vi(i,3)=vp
c          vi(i,5)=vloc
c          vi(i,7)=vloc
c        if (r(i).lt.2.) then
c        write (16,*) r(i),vs-vloc
c        write (17,*) r(i),vp-vloc
c        write (18,*) r(i),vloc
c        write (19,*) r(i),vs
c        write (20,*) r(i),vp
c                        endif
c	  enddo
c        close(16)
c        close(17)
c        close(18)
c        close(19)
c        close(20)
c                          endif
c
cc
c        if (ichar.eq.acs) then
c          njrc(1)=1
c          njrc(2)=1
c          njrc(3)=1
c          njrc(4)=1
c          do 53 i=1,nr
c          call vpss(r(i),vs,vp,vloc)
c          vi(i,1)=vs+vloc
c          vi(i,3)=vp+vloc
c          vi(i,5)=vloc
c          vi(i,7)=vloc
c 53       continue
c        endif


	goto 10

	end

c----------------------------------------------------------------------------
	subroutine getrb(nr,r,dr,rbar,phi,szz,alpha)
	implicit double precision (a-h,o-z)
	dimension r(2000),dr(2000),phi(2000)
	if (szz.le.0.d0) return
	rl=0.d0
	rh=1000000.d0
 2250   rbar=(rl+rh)/2.d0
c	write (6,2252) rl,rh,pzz,szz
 2252	format(1x,4d15.8)
        pzz=0.d0
        do 2260 j=1,nr
        f=1.d0-dexp(-(r(j)/rbar)**2.d0)
        c=f*f
        pzz=pzz+dr(j)*phi(j)*phi(j)*c*c*alpha/(2.d0*r(j)**4.d0)
 2260   continue
	if (rh.lt.0.000001d0) then
	  rbar=0.d0
	  return
	endif
        if (pzz.gt.szz) rl=rbar
        if (pzz.lt.szz) rh=rbar
	if (dabs(pzz-szz).gt.0.00000001d0) goto 2250
	return
	end
c----------------------------------------------------------------------------
c  this solves for the given electron configuration in the ionic potentials,
c  beginning with the bare nuclear or pseudopotential plus perhaps the 
c  effects of the pseudo core charge.

	subroutine abinitio(etot,nst,rel,nr,r,dr,r2,dl,
     1    phe,njrc,vi,zorig,xntot,nel,no,nl,xnj,
     1    ev,occ,is,ek,orb,iuflag)
	
	implicit double precision(a-h,o-z)

	dimension r(2000),dr(2000),r2(2000),v(2000)
	dimension no(40),nl(40),nm(40),xnj(40),ev(40),occ(40),is(40)
	dimension ek(40),phe(2000,40),dv(2,2000),njrc(4),vi(2000,9)
	dimension orb(2000,40),rpower(2000,0:15),dorb(2000,40)

c  this will be good for going up to and including l=3...
	do 10 i=0,7
	xi=i
	do 10 k=1,nr
	rpower(k,i)=r(k)**xi
 10	continue	

c  read in nfc, nel.  refer to the documentation for their meanings.

 168	write (6,*) 'PLEASE ENTER NFC, NEL, RATIO, ETOL, XNUM'
	read (15,*) nfc,nel,ratio,etol,xnum

c nel=# el., etol= conv. factor, ratio=mixing (new/old), nfc=#froz. core?
c  for all of the electrons, read in the quantum numbers.
c  get the total Hartree-active charge.  initialize eigenvalues.

	xntot=0.d0

	write (6,*) 'PLEASE ENTER N L M J S OCC.'

	do 100 i=nfc+1,nel
	read (15,*) no(i),nl(i),nm(i),xnj(i),is(i),occ(i)
	ev(i)=0.d0
	xntot=xntot+occ(i)
	do 100 j=1,nr
	phe(j,i)=0.d0
	orb(j,i)=0.d0
 100 	continue

c  initialize the parameters for self-consistency loop.
c  ratio is the mixture of old and new field mixing.

 110	call atsolve(etot,nst,rel,eerror,nfc,all,dv,nr,r,dr,r2,dl,phe,
     1    njrc,vi,zorig,xntot,nel,no,nl,nm,xnj,ev,occ,is,ek,
     1    ratio,orb,rpower,xnum,etot2,iuflag)

	eerror=eerror*(1.d0-ratio)/ratio
	write (6,112) eerror,etot
112	format (1x,3f14.6)
	if (eerror.gt.etol) goto 110

c  write out information about the atom.

 120	do 130 i=1,nel
	nj=xnj(i)+xnj(i)
	write (6,122) no(i),nl(i),nm(i),nj,'/2',is(i),occ(i),ev(i)
 122	format(1x,2i4,i2,i4,a2,i4,f10.4,f18.6)
 130	continue

	write (6,132) 'TOTAL ENERGY =  ',etot,etot*27.2116d0
 132	format (1x,a16,2f14.6)

	return

	end

c----------------------------------------------------------------------------

	subroutine atsolve(etot,nst,rel,eerror,nfc,
     1    all,dv,nr,r,dr,r2,dl,
     1    phe,njrc,vi,zorig,xntot,nel,no,nl,nm,xnj,ev,occ,is,ek,
     1    ratio,orb,rpower,xnum,etot2,iuflag)
	
	implicit double precision(a-h,o-z)

	dimension r(2000),dr(2000),r2(2000),v(2000)
	dimension no(40),nl(40),nm(40),xnj(40),ev(40),occ(40),is(40)
	dimension ek(40),phe(2000,40),dv(2,2000),njrc(4),vi(2000,9)
	dimension q0(2000),xm1(2000),xm2(2000),orb(2000,40)
	dimension dorb(2000,40),rpower(2000,0:15)

c  initialize eerror, the biggest change in an eigenvalue, and etot.

	eerror=0.d0
	etot=0.d0

c  run through all the orbitals.  calculate those not in the core.
c  if it is unoccupied and 'all' is zero, skip it.

	do 102 i=1,nel

	if (i.gt.nfc) then

	  idoflag=1
	 dnli=dfloat(nl(i))
	  call setqmm(i,orb,nl(i),dnli,is(i),idoflag,
     1      v,zeff,zorig,rel,
     1      nr,r,r2,dl,q0,xm1,xm2,njrc,vi)
	  if ((xnj(i).lt.0.d0).or.(occ(i).gt.1.d0)
     1     .or.(nl(i).eq.0.d0)) then
	    xkappa=-1.d0
	  else
	    if (is(i).eq.1) then
	      xkappa=nm(i)
	    else
	      xkappa=-nm(i)
	    endif
	  endif
	  call elsolve(i,occ(i),no(i),nl(i),xkappa,xnj(i),zorig,zeff,
     1      eguess,phe(1,i),v,q0,xm1,xm2,nr,r,dr,r2,dl,rel)
	  if (dabs(ev(i)-eguess).gt.eerror) eerror=dabs(ev(i)-eguess)
	  ev(i)=eguess

	  ekk=0.d0
	  ll=2
	  do 100 j=nr,1,-1
	  dq=phe(j,i)*phe(j,i)
	  ekk=ekk+(eguess-orb(j,i))*dr(j)*dq*dfloat(ll)/3.d0
	  ll=6-ll
 100	  continue
	  ek(i)=ekk

	endif	

c  add the kinetic to total, including the frozen core kinetic energy.

	etot=etot+ek(i)*occ(i)
 102	continue
	call getpot(etot,nst,rel,dl,nr,dr,r,r2,xntot,
     1    phe,ratio,orb,dorb,occ,is,nel,nl,nm,no,rpower,xnum,
     1    etot2,iuflag)

	return

	end

c-------------------------------------------------------------------------
c  determine the new potential, and add the potential energy to etot.

	subroutine getpot(etot,nst,rel,dl,nr,dr,r,r2,
     1    xntot,phe,ratio,orb,dorb,occ,is,nel,nl,nm,no,rpower,xnum,
     1    etot2,iuflag)

	implicit double precision(a-h,o-z)

	dimension dr(2000),r(2000),r2(2000)
	dimension dr2(2000),phe(2000,40),occ(40)
	dimension is(40),orb(2000,40),nl(40),nm(40),rpower(2000,0:15)
	dimension xq1(2000),xq2(2000),xq0(2000),no(40),dorb(2000,40)
	dimension cg(0:6,0:6,0:12,-6:6,-6:6),pin(0:8,0:8,0:16)
	dimension xqj0(2000),xqj1(2000)
	dimension xqj2(2000),xqi0(2000),xqi1(2000),xqi2(2000),rsp(2)

c  then, we add in the non-local exchange effects...this is done by dividing 
c  the non-local, inhomogeneous term of the radial equation by the w.f. at
c  that point in space, to make a local, potential, and then the equation is
c  homogeneous again.  This is an exact relation when we have self-con-
c  sistency, and so we hope to converge by mixing slowly enough.

	call clebschgordan(nel,nl,cg)
	call getillls(pin)

	ratio1=1.d0-ratio

	do 2000 i=1,nel
	do 2000 k=1,nr
	dorb(k,i)=orb(k,i)
	orb(k,i)=ratio1*orb(k,i)
 2000	continue

	do 2990 i=1,nel

	li=nl(i)
	mi=nm(i)

	jstart=i+1
	if (occ(i).gt.1.d0) jstart=i
	do 2990 j=jstart,nel

	lj=nl(j)
	mj=nm(j)

c  direct coulomb

	lmax=2*li
	if (li.gt.lj) lmax=2*lj

c  l=0 is monopole or spherical term for direct coulomb.  Therefore, 
c  when we have occ(i) or occ(j) greater than one, set lmax=0.	

	if ((occ(i).gt.1.d0).or.(occ(j).gt.1.d0)) lmax=0

	do 2550 la=lmax,0,-2
	lap=la+1

	coeff=dfloat((li+li+1)*(lj+lj+1))/dfloat((la+la+1))**2.d0*
     1    cg(li,li,la,mi,-mi)*cg(lj,lj,la,mj,-mj)*
     1    cg(li,li,la,0,0)*cg(lj,lj,la,0,0)
	if (mi+mj.ne.2*((mi+mj)/2)) coeff=-coeff
	if (i.eq.j) coeff=coeff/2.d0
	coeffi=occ(i)*coeff
	coeffj=occ(j)*coeff
	ri=ratio*coeffi
	rj=ratio*coeffj
	rc=coeff*occ(i)*occ(j)

	xouti=0.d0
	xoutj=0.d0
	do 2500 k=1,nr
	xqi0(k)=dr(k)*phe(k,i)*phe(k,i)/2.d0
	xqi1(k)=xqi0(k)*rpower(k,la)
	if (rpower(k,lap).ne.0.d0) then
	  xqi2(k)=xqi0(k)/rpower(k,lap)
	else
	  xqi2(k)=0.d0
	endif
	xouti=xouti+xqi2(k)
	xqj0(k)=dr(k)*phe(k,j)*phe(k,j)/2.d0
	xqj1(k)=xqj0(k)*rpower(k,la)
	if (rpower(k,lap).ne.0.d0) then
	  xqj2(k)=xqj0(k)/rpower(k,lap)
	else
	  xqj2(k)=0.d0
	endif
	xoutj=xoutj+xqj2(k)
 2500	continue

	xinti=xqi1(1)
	xintj=xqj1(1)
	xouti=2.d0*xouti-xqi2(1)
	xoutj=2.d0*xoutj-xqj2(1)

	do 2550 k=2,nr

	xinti=xinti+xqi1(k)+xqi1(k-1)
	xouti=xouti-xqi2(k)-xqi2(k-1)
	vali=xouti*rpower(k,la)
	if (rpower(k,lap).ne.0.d0) vali=vali+xinti/rpower(k,lap)
	orb(k,j)=orb(k,j)+ri*vali

	xintj=xintj+xqj1(k)+xqj1(k-1)
	xoutj=xoutj-xqj2(k)-xqj2(k-1)
	valj=xoutj*rpower(k,la)
	if (rpower(k,lap).ne.0.d0) valj=valj+xintj/rpower(k,lap)
	orb(k,i)=orb(k,i)+rj*valj

	etot=etot+rc*(xqi0(k)*valj+xqj0(k)*vali)

 2550	continue

	if ((is(i).ne.is(j)).and.(occ(i).le.1.d0).and.(occ(j).le.1.d0)) 
     1    goto 2990

c  exchange interaction

	lmax=li+lj
	lmin=iabs(mi-mj)
	if ((occ(i).gt.1.d0).or.(occ(j).gt.1.d0)) lmin=0
	do 2980 la=lmax,lmin,-2
	lap=la+1

	coeff=dfloat((li+li+1)*(lj+lj+1))/dfloat((la+la+1))**2.d0*
     1    (cg(li,lj,la,-mi,mj)*cg(li,lj,la,0,0))**2.d0
	if ((occ(i).gt.1.d0).or.(occ(j).gt.1.d0)) then
	  coeff=pin(li,lj,la)/4.d0
	endif
	if (i.eq.j) coeff=coeff/2.d0
	coeffi=occ(i)*coeff
	coeffj=occ(j)*coeff
	ri=ratio*coeffi
	rj=ratio*coeffj
	rc=coeff*occ(i)*occ(j)
	xnum2=xnum*xnum

	xout=0.d0
	do 2600 k=1,nr
	xq0(k)=dr(k)*phe(k,i)*phe(k,j)/2.d0
	xq1(k)=xq0(k)*rpower(k,la)
	if (rpower(k,lap).ne.0.d0) then
	  xq2(k)=xq0(k)/rpower(k,lap)
	else
	  xq2(k)=0.d0
	endif
	xout=xout+xq2(k)
 2600	continue
	xint=xq1(1)
	xout=2.d0*xout-xq2(1)
	do 2610 k=2,nr
	xint=xint+xq1(k)+xq1(k-1)
	xout=xout-xq2(k)-xq2(k-1)
	if (xq0(k).ne.0.d0) then
	  val=xout*rpower(k,la)
	  if (rpower(k,lap).ne.0.d0) val=val+xint/rpower(k,lap)
	  etot=etot-2.d0*xq0(k)*rc*val
	  xx=phe(k,j)/phe(k,i)
	  if (dabs(xx)/xnum.gt.1.d0) then
	    orb(k,i)=orb(k,i)-rj*xnum2/xx*val
	  else
	    orb(k,i)=orb(k,i)-rj*xx*val
	  endif
	  xx=phe(k,i)/phe(k,j)
	  if (dabs(xx)/xnum.gt.1.d0) then
	    orb(k,j)=orb(k,j)-ri*xnum2/xx*val
	  else
	    orb(k,j)=orb(k,j)-ri*xx*val
	  endif
	endif
 2610	continue

 2980   continue
 
 2990	continue

 8950	do 9000 i=1,nr
	if (iuflag.ne.0) then
	  jj=1
 8960	  ii=jj
 8965	  if (ii.eq.nel) goto 8970
	  icond=0
	  if ((no(jj).eq.no(ii+1)).and.(nl(jj).eq.nl(ii+1))
     1      .and.(iuflag.eq.2)) icond=1
	  if ((no(jj).eq.no(ii+1)).and.(nl(jj).eq.nl(ii+1))
     1      .and.(is(jj).eq.is(ii+1)).and.(iuflag.eq.1)) icond=1 
	  if (icond.eq.1) then
	    ii=ii+1
	    goto 8965
	  endif
 8970	  orba=0.d0
	  div=0.d0
	  do 8980 k=jj,ii
	  div=div+occ(k)
	  orba=orba+orb(i,k)*occ(k)
 8980	  continue
	  if (div.ne.0.d0) then
	    orba=orba/div
	    do 8990 k=jj,ii
	    orb(i,k)=orba
 8990	    continue
	  endif
	  if (ii.ne.nel) then
	    jj=ii+1
	    goto 8960
	  endif
	endif
	do 9000 j=1,nel
	dorb(i,j)=orb(i,j)-dorb(i,j)
 9000	continue
	return

	end

c------------------------------------------------------------------------
c  here is where we search for the energy.  We begin with 'eguess', and
c  integrate in and out and use the norm-conservation formula to guess 
c  the error in the eigenvalue.

	subroutine elsolve(i,occ,n,l,xkappa,xj,zorig,zeff,e,phi,v,
     1    q0,xm1,xm2,nr,r,dr,r2,dl,rel)

	implicit double precision(a-h,o-z)

	dimension phi(2000),phi2(2000),v(2000),q0(2000),xm1(2000)
	dimension r(2000),dr(2000),r2(2000),xm2(2000)

c  choose energy range

	el=-zorig*zorig/dfloat(n*n)
	eh=0.d0

c  set up tolerance in eigenvalue error

	etol=0.0000000001d0

 155	e=(el+eh)/2.d0

c  first, try to integrate out.

	istop=0
	nsav=n
c------------------  this is added in for the WS calculations  ----------
c                                                                       c
c                                                                       c
	if (n.lt.0) then
	  rs=4.868d0
	  istop=1.d0+dfloat(nr-1)*dlog(rs/r(1))/dlog(r(nr)/r(1))
	  nsav=1000
	  do 170 i=-200,0
	  e=dfloat(i)/1000.d0
	  call integ(e,l,xkappa,xj,nsav,nn,istop,ief,x0,phi,zeff,v,q0,xm1,
     1      xm2,nr,r,dr,r2,dl,rel)
	  write (6,162) '>>',e,x0,r(istop)
 162	  format (1x,a2,f6.3,2d15.8)
 170	  continue
	  return
	endif
c                                                                       c
c                                                                       c
c------------------------------------------------------------------------
	call integ(e,l,xkappa,xj,nsav,nn,istop,ief,x0,phi,zeff,v,q0,xm1,
     1    xm2,nr,r,dr,r2,dl,rel)

c  if we had too many nodes (ief=1), or too few nodes (ief=-1), the energy 
c  range is respectively truncated, and we set 'eguess'=0, to indicate that
c  we desire the next try still to do a binary search.  we crash if an 
c  occupied level is found to be unbound.

	if (nn.lt.n-l-1) ief=-1

 200	if (ief.ne.1) then
	  el=e
	  if (el.gt.-0.001d0) then
	    write (6,*) 'MIXING TOO STRONG FOR LEVEL : ',i
	    stop
	  endif
	endif

	if (ief.ne.-1) eh=e

 2222	format (1x,3f12.6,i4)

	if (eh-el.gt.etol) goto 155

	aa=0.d0
	do 6130 j=1,nr
	aa=aa+phi(j)*phi(j)*dr(j)
 6130	continue
	xnorm=dsqrt(aa)
	do 6140 j=1,nr
	phi(j)=phi(j)/xnorm
 6140 	continue

	return

	end

c-------------------------------------------------------------------------
c  this routine combines the ionic (pseudo)potential and the Hartree and
c  exchange/correlation potential, and implements the relativistic effects
c  and determines q0, which is the effective potential energy, including 
c  the angular momentum term.  Also, one can add in the ith. row of 'orb'
c  for inclusion of an orbital dependent potential.

	subroutine setqmm(i,orb,l,xj,ns,idoflag,v,zeff,zorig,rel,
     1    nr,r,r2,dl,q0,xm1,xm2,njrc,vi)

	implicit double precision(a-h,o-z)

	dimension v(2000),r(2000),r2(2000),orb(2000,40)
	dimension q0(2000),xm1(2000),xm2(2000),njrc(4),vi(2000,9)

c  rel=1 turns on relativity.

	c=137.038d0
	alpha=rel/c
	aa=alpha*alpha
	a2=aa/2.d0

	lp=l+1
	lpx=lp
	if (lp.gt.4) lpx=4
	lp2=l+l+1
	if (lp2.gt.7) lp2=7
	zeff=zorig
	if (njrc(lpx).gt.0) zeff=0.d0
	zaa=zeff*aa
	za2=zeff*a2

c  if idoflag is zero, we do not set up the potential again.  The option
c  of not affecting the potential is good for when one changes only the
c  angular momentum, for refiguring q0.  Derivatives of the potential are
c  needed to get relativistic (spin-orbit and Darwin) effects.  
c
c  if njrc(lp)=0, this means we have the full potential, and we get the
c  derivatives of the nuclear potential from analytic expressions.  for
c  njrc(lp) not = 0, then the get the new v, and differentiate it to 
c  get the derivatives.  xm1 and xm2 are the first and second derivatives
c  of the relativistic mass.

	if (idoflag.ne.0) then
	  if (njrc(lpx).eq.0) then
	    if (idoflag.eq.1) then
	      do 55 j=1,nr
	      v(j)=-zeff/r(j)+orb(j,i)
 55	      continue
	    endif
	    do 65 j=2,nr-1
     	    dvdl=(orb(j+1,i)-orb(j-1,i))/(2.d0*dl)
	    ddvdrr=((orb(j+1,i)
     1         +orb(j-1,i)-2.d0*orb(j,i) )/(dl*dl)-dvdl)/r2(j)
	    xm1(j)=-a2*dvdl/r(j)-za2/r2(j)
	    xm2(j)=-a2*ddvdrr+zaa/r2(j)/r(j)
 65	    continue
	    xm1(nr)=xm1(nr-1)
	    xm2(nr)=xm2(nr-1)
	    xm1(1)=xm1(2)+za2/r2(2)-za2/r2(1)
	    xm2(1)=xm2(2)-zaa/r2(2)/r(2)+zaa/r2(1)/r(1)
	  else
	    if (idoflag.eq.1) then
	      do 75 j=1,nr
	      if ((xj.eq.dfloat(l)).or.(l.eq.0)) then
	        v(j)=vi(j,lp2)
	      else if (xj.gt.dfloat(l)) then
	        v(j)=vi(j,lp2)+dfloat(l)*vi(j,lp2-1)/2.d0
	      else
	        v(j)=vi(j,lp2)-dfloat(l+1)*vi(j,lp2-1)/2.d0
	      endif
	      v(j)=v(j)+orb(j,i)
 75	      continue
	    endif
	    do 85 j=2,nr-1
	    dvdl=(v(j+1)-v(j-1))/(2.d0*dl)
	    ddvdrr=((v(j+1)+v(j-1)-2.d0*v(j))/(dl*dl)-dvdl)/r2(j)
	    xm1(j)=-a2*dvdl/r(j)
	    xm2(j)=-a2*ddvdrr
 85	    continue
	    xm1(nr)=xm1(nr-1)
	    xm2(nr)=xm2(nr-1)
	    xm1(1)=xm1(2)
	    xm2(1)=xm2(2)
	  endif
	endif

c  figure the (Desclaux-Numerov) effective potential.

	xlb=(dfloat(l)+0.5d0)**2.d0/2.d0
	do 45 j=1,nr
	vj=v(j)
	q0(j)=vj*(1.d0-a2*vj)+xlb/r2(j)
 45	continue

	return

	end
c-------------------------------------------------------------------------
c  this sets up the real potential
 
	subroutine initiali(zorig,nr,rmin,rmax,r,dr,r2,dl,njrc,
     1    xntot,nel)

	implicit double precision(a-h,o-z)

	dimension r(2000),dr(2000),r2(2000),njrc(4)

c  first, we get Z and NR, set up the grid, and initialize all
c  necessary variables.

	write (6,*) 'ENTER Z, NR'
	read (15,*) zorig,nr

	rmin=0.0001d0/zorig
	rmax=800.d0/dsqrt(zorig)
	call setgrid(nr,rmin,rmax,r,dr,r2,dl)

	do 5 j=1,4
	njrc(j)=0
 5	continue

	xntot=0.d0
	nel=0

	return

	end

c---------------------------------------------------------------------------
c  set up the radial logarithmic mesh.  the points are at the logarithmic
c  centers of the intervals; r2() is simply the squares of the grid points,
c  for accelerating computation.

	subroutine setgrid(nr,rmin,rmax,r,dr,r2,dl)

	implicit double precision(a-h,o-z)

	dimension r(2000),dr(2000),r2(2000)

	ratio=rmax/rmin
	dl=dlog(ratio)/dfloat(nr)
	xratio=dexp(dl)
	xr1=dsqrt(xratio)-dsqrt(1.d0/xratio)

	do 2010 i=1,nr
	r(i)=rmin*xratio**dfloat(i)
	dr(i)=r(i)*xr1
	r2(i)=r(i)*r(i)
 2010 	continue

	return

	end

c-----------------------------------------------------------------------------
c  this integrates out by the Numerov Algorithm (see Koonin, Computational
c  Physics, and Desclaux, Computer Physics Communication 1, 216 (1969).
c  Eq (8) in the latter is missing an r**2 factor on the right side of
c  the equation, in front of the whole expression.  Using the Numerov scheme
c  was suggested by Douglas C. Allan (private communication).

c  this routine is used for (1) eigenvalue search, and (2) when making 
c  the logarithmic derivative versus E curves, or generating pseudopotentials.

	subroutine integ(e,l,xkappa,xj,n,nn,istop,ief,x0,phi,z,v,q0,xm1,
     1    xm2,nr,r,dr,r2,dl,rel)

	implicit double precision(a-h,o-z)

	dimension phi(2000),v(2000),q0(2000),xm1(2000),xm2(2000)
	dimension r(2000),dr(2000),r2(2000)

c  set up constants.  'rel', when 1, turns on relativity.

	dl2=dl*dl/12.d0
	dl5=10.d0*dl2
	c=137.038d0
	alpha=rel/c
	za2=z*z*alpha*alpha
	a2=alpha*alpha/2.d0
	xl=l
	xlp=l+1
	xl2=0.5d0+xl
	xl4=xl2*xl2

c  then, we set up the leading power.
c  adjust for Desclaux's implementation of Numerov.

	if (rel.eq.0.d0) then
	  ss=xlp
	else
	  rtest=1.d0-za2
	  if (rtest.lt.0.d0) then
	    write (6,*) 'Z>137 IS TOO BIG.'
	    stop
	  endif  
	  ss=dsqrt(rtest)
	endif
	ss2=ss-0.5d0

c  we shall set ief to -1 if energy is too low, +1 if too high.

	ief=0

c  see Desclaux and documentation to see the origin of the below equations.
c  here, we set up the first two points.

	t=e-v(1)
	xm0=1.d0+a2*t
	tm=xm0+xm0
	xmx=xm1(1)/xm0
	xk0=r2(1)*(tm*t-xmx*(xkappa/r(1)+0.75d0*xmx)+xm2(1)/tm)-xl4
	dk0=1.d0+dl2*xk0
	p0=dk0
	phi(1)=p0*dsqrt(xm0*r(1))/dk0

	t=e-v(2)
	xm=1.d0+a2*t
	tm=xm+xm
	xmx=xm1(2)/xm
	xk2=r2(2)*(tm*t-xmx*(xkappa/r(2)+0.75d0*xmx)+xm2(2)/tm)-xl4
	dk2=1.d0+dl2*xk2
	p1=dk2*((r(2)/r(1))**ss2-(r(2)-r(1))*z/xlp)*dsqrt(xm0/xm)
	phi(2)=p1*dsqrt(xm*r(2))/dk2

c  if istop is set, the we know to stop there.  If it is zero, it shall
c  then be set to the classical turning point.

	is0=istop
	if (istop.eq.0) then
	  do 10 j=nr-1,2,-1
	  if (e.gt.v(j)) goto 15
 10	  continue
	  ief=-1
	  return
 15	  istop=j
	endif

c  initialize number of nodes, and determine the ideal number.

	nn=0
	nnideal=n-l-1

c  integrate out.  count nodes, and stop along the way if there are too many.

	do 50 i=3,istop+2
	t=e-v(i)
	xm=1.d0+a2*t
	tm=xm+xm
	xmx=xm1(i)/xm
	p2=(2.d0-dl5*xk2)*p1/dk2-p0
	xk2=r2(i)*(tm*t-xmx*(xkappa/r(i)+0.75d0*xmx)+xm2(i)/tm)-xl4
	dk2=1.d0+dl2*xk2
	phi(i)=p2*dsqrt(xm*r(i))/dk2
	if (dabs(p2).gt.10000000000.d0) then
	  do 20 j=1,i
	  phi(j)=phi(j)/p2
 20	  continue
	  p0=p0/p2
	  p1=p1/p2
	  p2=p2/p2
	endif
	if (p2*p1.lt.0.d0) then
	  nn=nn+1
	  if (nn.gt.nnideal) then
	    ief=1
	    return
	  endif
	endif
	p0=p1
	p1=p2
 50	continue

	if (istop.gt.0) then
	  psip2=(phi(istop+2)-phi(istop-2))
	  psip1=(phi(istop+1)-phi(istop-1))
	  psip=(8.d0*psip1-psip2)/(12.d0*dl*r(istop))
	  x0=psip/phi(istop)
	endif

	if (is0.eq.0) then
	  do 150 i=istop+3,nr-1
	  t=e-v(i)
	  xm=1.d0+a2*t
	  tm=xm+xm
	  xmx=xm1(i)/xm
	  p2=(2.d0-dl5*xk2)*p1/dk2-p0
	  if (p2/p1.gt.1.d0) then
	    ief=-1
	    return
	  endif
	  xk2=r2(i)*(tm*t-xmx*(xkappa/r(i)+0.75d0*xmx)+xm2(i)/tm)-xl4
	  dk2=1.d0+dl2*xk2
	  phi(i)=p2*dsqrt(xm*r(i))/dk2
	  if (dabs(p2).gt.10000000000.d0) then
	    do 120 j=1,i
	    phi(j)=phi(j)/p2
 120	    continue
	    p0=p0/p2
	    p1=p1/p2
	    p2=p2/p2
	  endif
	  if (p2*p1.lt.0.d0) then
	    nn=nn+1
	    if (nn.gt.nnideal) then
	      ief=1
	      return
	    endif
	  endif
	  p0=p1
	  p1=p2
 150	  continue
	endif

	return

	end

c-------------------------------------------------------------------------
c  routine to generate Clebsch-Gordan coefficients, in the form of 
c  cg(l1,l2,L,m1,m2) = <l1,m1;l2,m2|L,m1+m2>, according to Rose's 
c  'Elementary Theory of Angular Momentum', p. 39, Wigner's formula.
c  those coefficients listed are only those for which l1.ge.l2.
c  coefficients known to be zero because of either the L or M 
c  selection rules are not computed, and should not be sought.

	subroutine clebschgordan(nel,nl,cg)

	implicit double precision(a-h,o-z)

	dimension nl(40)
	dimension cg(0:6,0:6,0:12,-6:6,-6:6),si(0:32),fa(0:32)

	lmax=0
	do 14 i=1,nel
	if (nl(i).gt.lmax) lmax=nl(i)
 14	continue

	si(0)=1.d0
	fa(0)=1.d0
	do 50 i=1,32
	si(i)=-si(i-1)
	fa(i)=dfloat(i)*fa(i-1)
 50	continue

	do 100 l1=0,lmax
	do 100 l2=0,l1
 52	format (1x,i3,a3,i3)
	do 100 m1=-l1,l1
	do 100 m2=-l2,l2
	m3=m1+m2
	lmin=iabs(l1-l2)
	if (lmin.lt.iabs(m3)) lmin=iabs(m3)
	do 100 l3=lmin,l1+l2
	prefactor=dfloat(2*l3+1)
	prefactor=prefactor*fa(l3+l1-l2)/fa(l1+l2+l3+1)
	prefactor=prefactor*fa(l3-l1+l2)/fa(l1-m1)
	prefactor=prefactor*fa(l1+l2-l3)/fa(l1+m1)
	prefactor=prefactor*fa(l3+m3)/fa(l2-m2)
	prefactor=prefactor*fa(l3-m3)/fa(l2+m2)
	prefactor=dsqrt(prefactor)
	sum=0.d0
	numax=l3-l1+l2
	if ((l3+m3).lt.numax) numax=l3+m3
	numin=0
	if (l1-l2-m3.lt.numin) numin=-(l1-l2-m3)
	do 90 nu=numin,numax
	sum=sum+(si(nu+l2+m2)/fa(nu))*fa(l2+l3+m1-nu)*fa(l1-m1+nu)
     1    /fa(l3-l1+l2-nu)/fa(l3+m3-nu)/fa(nu+l1-l2-m3)
 90	continue
	cg(l1,l2,l3,m1,m2)=prefactor*sum
	cg(l2,l1,l3,m2,m1)=si(l1+l2+l3)*prefactor*sum
 100	continue

	return

	end
	include 'hfdisk2.f'
	include 'hfgi.f'
	include 'pseudg.f'
