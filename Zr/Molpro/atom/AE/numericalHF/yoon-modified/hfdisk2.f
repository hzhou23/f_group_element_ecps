c  procedure to write the information to disk

	subroutine atomwrite(etot,nst,rel,nr,rmin,rmax,zorig,xntot,
     &   ixflag,
     &	nel,no,nl,xnj,is,ev,ek,occ,njrc,vi,cq,rho,vhxc,phe,orb,r)

	implicit double precision(a-h,o-z)

	dimension no(40),nl(40),xnj(40),is(40),ev(40),ek(40),occ(40),
     &		njrc(4),vi(2000,7),rho(2,2000),cq(2000),
     &		vhxc(2,2000),phe(2000,40),a(7),orb(2000,40),r(2000)

	character*10 filename
 52	format (a10)

	write (6,*) 'PLEASE ENTER FULL FILENAME.'
	read (15,52) filename

	open (unit=1,status='unknown',file=filename)

	write (1,102)  etot, nst,  rel, nr,  rmin,  rmax, zorig, xntot, nel 
 102	format (f15.6,i2,f4.1,i5,d15.8,d15.8,f6.1,f12.8,i3)
	write (1,112)  ixflag
 112	format (i4)

	do 200 j=1,nel
	write (1,152) no(j), nl(j), xnj(j), is(j), ev(j), ek(j), occ(j) 
 152	format (i3,i2,f4.1,i2,f12.6,f12.6,f12.8)
 200	continue

	write (1,202) njrc(1),njrc(2),njrc(3),njrc(4)
 202	format (4i5)
	ntot=0
	if (njrc(1).ne.0) ntot=1
	if (njrc(2).ne.0) ntot=ntot+2
	if (njrc(3).ne.0) ntot=ntot+2
	if (njrc(4).ne.0) ntot=ntot+2

	if (ntot.ne.0) then
	  do 300 i=1,nr
	  n=0
	  if (njrc(1).ne.0) then
	    n=1
	    a(n)=vi(i,1)
	  endif
	  if (njrc(2).ne.0) then
	    n=n+2
	    a(n-1)=vi(i,2)
	    a(n)=vi(i,3)
	  endif
	  if (njrc(3).ne.0) then
	    n=n+2
	    a(n-1)=vi(i,4)
	    a(n)=vi(i,5)
	  endif
	  if (njrc(4).ne.0) then
	    n=n+2
	    a(n-1)=vi(i,6)
	    a(n)=vi(i,7)
	  endif
	  write (1,252) (a(j), j=1,n)
 252	  format (7d15.8)
 300	  continue
	endif

c	do 400 i=1,nr
c	write (1,252) rho(1,i),rho(2,i),cq(i),vhxc(1,i),vhxc(2,i)
c 400	continue

c	do 600 i=1,nel
c	if ((ev(i).lt.1.d0).or.(njrc(nl(i)+1).ne.0)) then
c	  do 500 j=1,nr
c	  write (1,452) phe(j,i)
c	  if (ixflag.eq.1) write (1,452) orb(j,i)
c 452	  format (1x,d15.8)
c 500	  continue
c	endif
c 600	continue
	dummy=0.
	write (25,*) nel, zorig
	do 700 i=1,nel
	if (i.gt.1.and.nl(i).eq.nl(i-1).and.no(i).eq.no(i-1))
     &                                              go to 700
		sss=1.d+00
		do 650 irev=nr-30,1,-1
		if (abs(phe(irev,i)).gt.1.e-2)	go to 660
 650		continue
 660		continue
	if (phe(irev,i).lt.0.)	sss=-1.d+00
		do lr=1,nr
		if(r(lr).gt.120.)        go to 685
		enddo
685		continue
		nra=lr-1
	write (25,*) nra,nl(i)
		do 690 lr=1,nra
		write (27,*) sngl(r(lr)),sngl(phe(lr,i)*sss)
		write (26,*) sngl(r(lr)),sngl(phe(lr,i)*sss/r(lr))
		write (25,*) lr,r(lr),phe(lr,i)*sss,dummy,dummy
		write (28,*) r(lr),phe(lr,i)*sss/r(lr)**(nl(i)+1)
 690		continue
	write (26,*) ' 20. 0.'
	write (26,*) ' 20. -100000.'
	write (26,*) ' 0. -100000.'
        write (27,*) ' 20. 0.'
        write (27,*) ' 20. -100000.'
        write (27,*) ' 0. -100000.'
        write (28,*) ' 20. 0.'
        write (28,*) ' 20. -100000.'
        write (28,*) ' 0. -100000.'
 700	continue
c
	close (unit=1)

	return

	end


c  procedure to read a file from disk

	subroutine atomread(etot,nst,rel,nr,rmin,rmax,zorig,xntot,
     &   ixflag,
     &	nel,no,nl,xnj,is,ev,ek,occ,njrc,vi,cq,rho,vhxc,phe,orb)

	implicit double precision(a-h,o-z)

	dimension no(40),nl(40),xnj(40),is(40),ev(40),ek(40),occ(40),
     &		njrc(4),vi(2000,7),rho(2,2000),cq(2000),
     &		vhxc(2,2000),phe(2000,40),a(7),orb(2000,40)

	character*10 filename

	write (6,*) 'PLEASE ENTER FULL FILENAME.'
	read (5,52) filename
 52	format (a10)

	open (unit=1,status='unknown',file=filename)

	read  (1,102)  etot, nst,  rel, nr,  rmin,  rmax, zorig, xntot, nel 
 102	format (f15.6,i2,f4.1,i5,d15.8,d15.8,f6.1,f12.8,i3)
	read (1,112) ixflag
 112	format (i4)

	do 200 j=1,nel
	read  (1,152) no(j), nl(j), xnj(j), is(j), ev(j), ek(j), occ(j) 
 152	format (i3,i2,f4.1,i2,f12.6,f12.6,f12.8)
 200	continue

	read  (1,202) njrc(1),njrc(2),njrc(3),njrc(4)
 202	format (4i5)
	ntot=0
	if (njrc(1).ne.0) ntot=1
	if (njrc(2).ne.0) ntot=ntot+2
	if (njrc(3).ne.0) ntot=ntot+2
	if (njrc(4).ne.0) ntot=ntot+2

	if (ntot.ne.0) then
	  do 300 i=1,nr
	  read (1,252) (a(j), j=1,ntot)
	  n=0
	  if (njrc(1).ne.0) then
	    n=1
	    vi(i,1)=a(n)
	  endif
	  if (njrc(2).ne.0) then
	    n=n+2
	    vi(i,2)=a(n-1)
	    vi(i,3)=a(n)
	  endif
	  if (njrc(3).ne.0) then
	    n=n+2
	    vi(i,4)=a(n-1)
	    vi(i,5)=a(n)
	  endif
	  if (njrc(4).ne.0) then
	    n=n+2
	    vi(i,6)=a(n-1)
	    vi(i,7)=a(n)
	  endif
 252	  format (7d15.8)
 300	  continue
	endif

	do 400 i=1,nr
	read (1,252) rho(1,i),rho(2,i),cq(i),vhxc(1,i),vhxc(2,i)
 400	continue

	do 600 i=1,nel
	if ((ev(i).lt.1.d0).or.(njrc(nl(i)+1).ne.0)) then
	  do 500 j=1,nr
	  read (1,452) phe(j,i)
	  if (ixflag.eq.1) read (1,452) orb(j,i)
 452	  format (1x,d15.8)
 500	  continue
	endif
 600	continue

	close (unit=1)

	return

	end
