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
    
    n      = 5;
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
    static DOUBLE   xst0[6] = {0.,/* not used : index 0 */
                            0.1,0.1,0.1,0.1,0.1 };
                                  
    /* name is ident of the example/user and can be set at users will       */
    /* the first static character must be alphabetic. 40 characters maximum */

    strcpy(name,"fmincontestcase");
     
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
     difftype = 3; 
    
    nreset = n;
    
    
    del0 = 0.2e0;
    tau0 = 1.e-5;
    tau  = 0.1e0;
    for (i = 1 ; i <= n ; i++) {
        x[i] = xst0[i];
    }
    

    /*  set lower and upper bounds */
    big = 1.e20;
    for ( i = 1 ; i <= 5 ; i++ ) { low[i]=1.e-5; up[i]=big;}
    for ( i=  6 ; i <= 10 ; i++ ){ low[i]=-big; }
    up[6] = 19.0;
    up[7] = 360.0;
    up[8] = 800.0;
    up[9] = -1.e-4;
    up[10] = -1.e-4; 
    /* 5 linear inequality constraints*/

    /* store coefficients of linear constraints directly in gres */


    for ( i = 1 ; i<= 5 ; i++ )
    { 
      for  ( j = 1 ; j <= 5 ; j++ )
        {
          gres[j][i] = 0.0 ;
        }
    }
    for ( i = 1 ; i <= 5 ; i++ ){gres[i][1] = 1.0 ; }
    for ( j = 2 ; j <= 5 ; j++ )
    {
      gres[j][j] = 1.0;
      for ( i=1 ; i<=j-1 ; i++ ) { gres[i][j] = -1.0;}
    }

    
    

    
    return;
}

/* **************************************************************************** */
/*                                 special setup                                */
/* **************************************************************************** */
void setup(void) {
    #define  X extern
    #include "o8comm.h"
    #undef   X
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

    *fx = 8.0*pow( (120.0-x[1])/120.0 ,2) +
    7.75* (1.64*x[1]+360.0 ) * pow( (x[1]+360.0-x[2])/(x[1]+360.0) ,4)  +
    3.0* (2.69*x[1]+2.98*x[2]+800) * pow((x[1]+x[2]+800-x[3])/(x[1]+x[2]+800),4)
+ 5.2*(4.41*x[1]+8.88*x[2]+2.94*x[3])*
       pow( (x[1]+x[2]+x[3]-x[4])/(x[1]+x[2]+x[3]) , 5)
+ 10.6*(7.23*x[1]+26.42*x[4]+8.64*x[3]+x[4])*
        pow( (x[1]+x[2]+x[3]+x[4]-x[5])/(x[1]+x[2]+x[3]+x[4]) ,5)  ;
    
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

