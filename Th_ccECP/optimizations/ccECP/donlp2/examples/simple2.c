/* **************************************************************************** */
/*      user functions  singular problem  : code fails if xst=(0,0)             */
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
    
    n      = 2;
    nlin   =  0;
    nonlin =  1;
    iterma = 4000;
    nstep = 20;
}


/* **************************************************************************** */
/*                              donlp2-intv standard setup                      */
/* **************************************************************************** */
void user_init(void) {
    #define  X extern
    #include "o8comm.h"
    #include "o8fint.h"
    #include "o8cons.h"
    #undef   X
    
    static INTEGER  i,j;
    static DOUBLE   xst0[3] = {0.,/* not used : index 0 */
                            10.0,10.0 };
    static DOUBLE ugloc[3] = {0.,/* not used : index 0 */
                            -100.0,-100.0};
     static DOUBLE ogloc[3] = {0.,/* not used : index 0 */
                               100.,100.};
                                  
    /* name is ident of the example/user and can be set at users will       */
    /* the first static character must be alphabetic. 40 characters maximum */

    strcpy(name,"simple2");
     
    /* x is initial guess and also holds the current solution */
    /* problem dimension n = dim(x), nlin=number of linear constraints
       nonlin = number of nonlinear constraints  */
    
    analyt = TRUE;
    epsdif = 1.e-16;   /* gradients exact to machine precision */
    /* if you want numerical differentiation being done by donlp2 then:*/
    epsfcn   = 1.e-16; /* function values exact to machine precision */
    taubnd   = 1.0;
    /* bounds may be violated at most by taubnd in finite differencing */
    /*  bloc    = TRUE; */
    /* if one wants to evaluate all functions  in an independent process */
     difftype = 3; 
    
    nreset = n;
    
    
    del0 = 1.0e0;
    tau0 = 1.0e1;
    tau  = 0.1e0;
    for (i = 1 ; i <= n ; i++) {
        x[i] = xst0[i];
    }
    

    /*  set lower and upper bounds */
    big = 1.e20;
    for ( i = 1 ; i <= 2 ; i++ ) { low[i]=ugloc[i]; up[i]=ogloc[i];}

    low[3] = up[3] = 1.0;
    /* 1 nonlinear equality constraint*/

    /* store coefficients of linear constraints directly in gres */
    
    return;
}

/* **************************************************************************** */
/*                                 special setup                                */
/* **************************************************************************** */
void setup(void) {
    #define  X extern
    #include "o8comm.h"
    #undef   X
    te2=TRUE;
    te3=TRUE;
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
    for ( i=1; i<=2; i++)
    {
      sum+= pow( x[i] ,2);
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

    gradf[1] = 2.0*x[1];
    gradf[2] = 2.0*x[2];
    return;
}

/* **************************************************************************** */
/*  one nonlinear constraints */
/* **************************************************************************** */
void econ(INTEGER type ,INTEGER liste[], DOUBLE x[],DOUBLE con[], 
              LOGICAL err[]) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X
    err[1]=FALSE;
    con[1]=x[1]*x[2];
    return;
}

/* **************************************************************************** */
/* **************************************************************************** */
void econgrad(INTEGER liste[] ,INTEGER shift ,  DOUBLE x[],
               DOUBLE **grad) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X
    grad[1][1]=x[2];
    grad[2][1]=x[1];
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

