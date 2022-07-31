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
    
    n      = 13;
    nlin   =  5;
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
    #include "o8fint.h"
    #include "o8cons.h"
    #undef   X
    
    static INTEGER  i,j;
    static DOUBLE   xst0[14] = {0.,/* not used : index 0 */
                            10.e0,10.e0, 10.e0, 10.e0, 10.e0, 10.e0,
                       10.e0 ,10.e0 , 10.e0 , 10.e0 , 10.e0 ,10.e0 , 10.e0 };
    static DOUBLE ugloc[14] = {0.,/* not used : index 0 */
                            0.,0.,0.2,0.,0.,0.1,0.,0.,0.,0.,0.,0.,0.};
     static DOUBLE ogloc[14] = {0.,/* not used : index 0 */
                               1.,1.,1.,1.,1.,1.,1.,1.,1.,1.,1.,1.,1.};
                                  
    /* name is ident of the example/user and can be set at users will       */
    /* the first static character must be alphabetic. 40 characters maximum */

    strcpy(name,"portfol2");
     
    /* x is initial guess and also holds the current solution */
    /* problem dimension n = dim(x), nlin=number of linear constraints
       nonlin = number of nonlinear constraints  */
    
    analyt = FALSE;
    epsdif = 1.e-16;   /* gradients exact to machine precision */
    /* if you want numerical differentiation being done by donlp2 then:*/
    epsfcn   = 1.e-16; /* function values exact to machine precision */
    taubnd   = 1.0;
    /* bounds may be violated at most by taubnd in finite differencing */
    /*  bloc    = TRUE; */
    /* if one wants to evaluate all functions  in an independent process */
     difftype = 2; 
    
    nreset = n;
    
    
    del0 = 0.2e0;
    tau0 = 1.e0;
    tau  = 0.1e0;
    for (i = 1 ; i <= n ; i++) {
/*!!! change initial vector */
        x[i] = -xst0[i];
    }
    

    /*  set lower and upper bounds */
    big = 1.e20;
    for ( i = 1 ; i <= 13 ; i++ ) { low[i]=ugloc[i]; up[i]=ogloc[i];}

    low[14] = up[14] = 1.0;
    low[15] = up[15] = 0.35;
    low[16] = up[16] = 0.3;
    low[17] = up[17] = 0.35;
    low[18]=0.3;
    up[18] = big; 
    /* 4 linear equality constraints*/

    /* store coefficients of linear constraints directly in gres */


    for ( i = 2 ; i<= 5 ; i++ )
    { 
      for  ( j = 1 ; j <= 13 ; j++ )
        {
          gres[j][i] = 0.0 ;
        }
    }
    for ( j =1 ; j <= 13 ; j ++) gres[j][1] = 1.0 ;
    gres[1][2] = 1.0;
    gres[2][2] = 1.0; 
    for ( j =9 ; j<=13; j++ ) { gres[j][2]=1.0; gres[j][5] = 1.0 ; }
    gres[3][3] = 1.0;
    gres[4][3] = 1.0;
    gres[5][3] = 1.0 ; 
    gres[6][4] = 1.0;
    gres[7][4] = 1.0;
    gres[8][4] =1.0;
    

    
    return;
}

/* **************************************************************************** */
/*                                 special setup                                */
/* **************************************************************************** */
void setup(void) {
    #define  X extern
    #include "o8comm.h"
    #undef   X
    te0=TRUE;
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
    static double aloc[14] = { 0., 0.05,  0.1, 0.15, 0.08, 0.07, 0.1,
                            0.13, 0.12, 0.056, 0.021, 0.063,0.036, 0.024};
    static int i; 
    static double sum;
    sum=0.0;
    for ( i=1; i<=13; i++)
    {
      sum+= pow( ( (x[i]-aloc[i])/aloc[i] ) ,2);
    }
    *fx = sum;
    
    return;
}

/* **************************************************************************** */
/*                          gradient of objective function                      */
/* **************************************************************************** */
void egradf(DOUBLE x[],DOUBLE gradf[]) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X

    
    return;
}

/* **************************************************************************** */
/*  no onlinear constraints */
/* **************************************************************************** */
void econ(INTEGER type ,INTEGER liste[], DOUBLE x[],DOUBLE con[], 
              LOGICAL err[]) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X

    return;
}

/* **************************************************************************** */
/* **************************************************************************** */
void econgrad(INTEGER liste[] ,INTEGER shift ,  DOUBLE x[],
               DOUBLE **grad) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X
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

