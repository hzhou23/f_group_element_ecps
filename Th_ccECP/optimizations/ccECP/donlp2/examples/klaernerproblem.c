/* **************************************************************************** */
/*                                 TESTAUFGABE 6                             */
/*   n = 4 , zusaetzlicher Linearanteil     */
/*    Randbedingungen so gewaehlt, dass Loesung  davon beeinflusst wird                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        auf dem Rand liegt                   */
/*  */
/* **************************************************************************** */


/* **************************************************************************** */
/*                                 user functions                               */
/* **************************************************************************** */
#include "o8para.h"

main() {
    void donlp2(void);
    
    donlp2();
    
    exit(0);
}

/* **************************************************************************** */
/*                              donlp2-intv size initialization                           */
/* **************************************************************************** */
void user_init_size(void) {
    #define  X extern
    #include "o8comm.h"
    #include "o8fint.h"
    #include "o8cons.h"
    #undef   X


    /* problem dimension n = dim(x), nlin=number of linear constraints
       nonlin = number of nonlinear constraints  */
    
    n      =  4;
    nlin   =  0;
    nonlin =  0;
    iterma = 4000;
    nstep = 20;
}


/* **************************************************************************** */
/*                              donlp2-intv standard setup                           */
/* **************************************************************************** */
void user_init(void) {
    #define  X extern
    #include "o8comm.h"
    #include "o8cons.h"
    #undef   X
    

static INTEGER  i,j;

/*starting vector x0 : */
  static DOUBLE   xst0[5] = {0.,/* not used : index 0 */  -1 ,5 ,-2, 0.5};
/*vector of lower bounds : */				
  static DOUBLE ugloc[5] = {0.,/* not used : index 0 */ 
 -100000, 4, -100000,-100000 };
   
/*vector of upper bounds : */			     
  static DOUBLE ogloc[5] = {0.,/* not used : index 0 */ 
   100000, 100000, 100000 ,100000};
			

    /* name is ident of the example/user and can be set at users will       */
    /* the first static character must be alphabetic. 40 characters maximum */
    /* the first 8 chars give the name of the .mes and .pro files */

    strcpy(name,"Problem");


    /* x is initial guess and also holds the current solution */
    /* problem dimension n = dim(x), nlin=number of linear constraints
       nonlin = number of nonlinear constraints  */
    
    analyt = TRUE;
    epsdif=1.0e-16;
    /****    epsdif = 1.e-32;    gradients exact to machine precision */
    /* if you want numerical differentiation being done by donlp2 then:*/
    /* epsfcn   = 1.e-16; *//* function values exact to machine precision */
    /* taubnd   = 5.e-6; */
    /* bounds may be violated at most by taubnd in finite differencing */
    /*  bloc    = TRUE; */
    /* if one wants to evaluate all functions  in an independent process */
    /* difftype = 3; *//* the most accurate and most expensive choice */
    
     nreset = n;
    
 
    del0 = 0.10e0;
    tau0 = 0.5e0;
    tau  = 0.5e0;
     

   for (i = 1 ; i <= n ; i++) {
        x[i] = xst0[i];
    }
 
    /*  set lower and upper bounds */
    /* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! */
	 big = 1.e20;  /* -> !=! INFINITY  !!!!! */
    for ( i = 1 ; i <= 4 ; i++ ) { low[i]=ugloc[i]; up[i]=ogloc[i];}

    
    return;
}

/* **************************************************************************** */
/*                                 special setup                                */
/* **************************************************************************** */
void setup(void) {
    #define  X extern
    #include "o8comm.h"
    #undef   X
	 te0=FALSE; /* one-line-outout for every step on console makes no sense
if TE2 and/or TE3=TRUE  */
	 te1=TRUE; /* post-mortem-dump of accumulated informtion in accinf */
    return;
}

/* **************************************************************************** */
/*  the user may add additional computations using the computed solution here   */
/* **************************************************************************** */
void solchk(void) {
    #define  X extern
    #include "o8comm.h"
    #undef   X
    #include "o8cons.h"

    return;
}

/* **************************************************************************** */
/*                               objective function                             */
/* **************************************************************************** */
void ef(DOUBLE x[],DOUBLE *fx) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X
/* !!!!!!! 5/2=2 in c   !!!!!!!*/
    *fx = 5.0/2.0*pow(x[1],2)+7.0/2.0*pow(x[2],2)+3.0/2.0*pow(x[3],2)+pow(x[4],2)
         +4.0*x[1]+3.0*x[2]+5.0*x[3]+7.0*x[4]
 		;  
	 return;
}

/* **************************************************************************** */
/*                          gradient of objective function                      */
/* **************************************************************************** */
void egradf(DOUBLE x[],DOUBLE gradf[]) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X

    static INTEGER  j;
      gradf[1] =5*x[1]+4  ;
 
	gradf[2] =7*x[2]+3   ;
  
	gradf[3] =3*x[3]+5  ;
 
	gradf[4] =2*x[4]+7  ; 
		
	     return;
}


/* **************************************************************************** */
/*                        user functions (if bloc == TRUE)                      */
/* **************************************************************************** */
void eval_extern(INTEGER mode) {
    #define  X extern
    #include "o8comm.h"
    #include "o8fint.h"
    #undef   X
    #include "o8cons.h"

    return;
}




/* **************************************************************************** */
/*  no nonlinear constraints */
/* **************************************************************************** */
void econ(INTEGER type ,INTEGER liste[], DOUBLE x[],DOUBLE con[], 
              LOGICAL err[]) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X

    return;
}

/* **************************************************************************** */
/*  no nonlinear constraints */
/* **************************************************************************** */
void econgrad(INTEGER liste[] ,INTEGER shift ,  DOUBLE x[],
               DOUBLE **grad) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X
    return; 
}
 

