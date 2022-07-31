#include "o8para.h"
main() {
    void donlp2(void);
    
    donlp2();
    
    exit(0);
}

/* **************************************************************************** */
/*                                 user functions                               */
/* **************************************************************************** */

static DOUBLE  wd[101];

static DOUBLE  wa[][21] = {
{0.,    0.    ,0.    ,0.    ,0.    ,0.    ,0.    ,0.    ,0.    ,0.    ,0.    ,
            0.    ,0.    ,0.    ,0.    ,0.    ,0.    ,0.    ,0.    ,0.    ,0.    },
        
{0.,    1.e0  , .95e0,1.e0  ,1.e0  ,1.e0  , .85e0, .9e0 , .85e0, .8e0 ,1.e0  ,  
            1.e0  ,1.e0  ,1.e0  ,1.e0  ,1.e0  ,1.e0  ,1.e0  , .95e0,1.e0  ,1.e0  }, 
{0.,     .84e0, .83e0, .85e0, .84e0, .85e0, .81e0, .81e0, .82e0, .8e0 , .86e0,  
            1.e0  , .98e0,1.e0  , .88e0, .87e0, .88e0, .85e0, .84e0, .85e0, .85e0}, 
{0.,     .96e0, .95e0, .96e0, .96e0, .96e0, .90e0, .92e0, .91e0, .92e0, .95e0,  
             .99e0, .98e0, .99e0, .98e0, .97e0, .98e0, .95e0, .92e0, .93e0, .92e0}, 
{0.,    1.e0  ,1.e0  ,1.e0  ,1.e0  ,1.e0  ,1.e0  ,1.e0  ,1.e0  ,1.e0  , .96e0,  
             .91e0, .92e0, .91e0, .92e0, .98e0, .93e0,1.e0  ,1.e0  ,1.e0  ,1.e0  }, 
{0.,     .92e0, .94e0, .92e0, .95e0, .95e0, .98e0, .98e0,1.e0  ,1.e0  , .90e0,
             .95e0, .96e0, .91e0, .98e0, .99e0, .99e0,1.e0  ,1.e0  ,1.e0  ,1.e0  }};
    
static DOUBLE  wc[] = {0., /* not used : index 0 */
                    2.e2,1.e2,3.e2,1.5e2,2.5e2};

static DOUBLE  wb[] = {0., /* not used : index 0 */
                    30.e0,1.e2,4.e1,5.e1,7.e1,35.e0,1.e1};

static INTEGER wj[] = {0, /* not used : index 0 */
                    1,6,10,14,15,16,20};

static DOUBLE  wu[] = {0., /* not used : index 0 */
                    6.e1,5.e1,5.e1,75.e0,4.e1,6.e1,3.5e1,3.e1,2.5e1,1.5e2,3.e1,
                    4.5e1,1.25e2,2.e2,2.e2,1.3e2,1.e2,1.e2,1.e2,1.5e2};

/* **************************************************************************** */
/*                              donlp2 standard setup                           */
/* **************************************************************************** */
void user_init_size(void) {
    #define  X extern
    #include "o8comm.h"
    #include "o8fint.h"
    #include "o8cons.h"
    #undef   X


    /* problem dimension n = dim(x), nlin=number of linear constraints
       nonlin = number of nonlinear constraints  */
    
    n      = 100;
    nlin   =  0; /* for simplicity of transforming the code */
    nonlin =  12;
    iterma = 4000;
    nstep = 20;
}





void user_init(void) {
    #define  X extern
    #include "o8comm.h"
    #include "o8fint.h"
    #include "o8cons.h"

    #undef   X
    
    static INTEGER i,j,nuser = 100;

    static DOUBLE xst0[] = {0., /* not used : index 0 */
         6.e0, 6.e0, 6.e0, 6.e0, 6.e0, 1.e0, 1.e0, 1.e0, 1.e0, 1.e0,
         1.e0, 1.e0, 1.e0, 1.e0, 1.e0, 1.e0, 1.e0, 1.e0, 1.e0, 1.e0,
         1.e0, 1.e0, 1.e0, 1.e0, 1.e0,20.e0,20.e0,20.e0,20.e0,20.e0,
         1.e0, 1.e0, 1.e0, 1.e0, 1.e0, 1.e0, 1.e0, 1.e0, 1.e0, 1.e0,
         1.e0, 1.e0, 1.e0, 1.e0, 1.e0, 8.e0, 8.e0, 8.e0, 8.e0, 8.e0,
         1.e0, 1.e0, 1.e0, 1.e0, 1.e0, 1.e0, 1.e0, 1.e0, 1.e0, 1.e0,
         1.e0, 1.e0, 1.e0, 1.e0, 1.e0,10.e0,10.e0,10.e0,10.e0,10.e0,
        12.e0,12.e0,12.e0,12.e0,12.e0, 7.e0, 7.e0, 7.e0, 7.e0, 7.e0,
         1.e0, 1.e0, 1.e0, 1.e0, 1.e0, 1.e0, 1.e0, 1.e0, 1.e0, 1.e0,
         1.e0, 1.e0, 1.e0, 1.e0, 1.e0, 3.e0, 3.e0, 3.e0, 3.e0, 3.e0  };
        
    /* name is ident of the example/user and can be set at users will           */
    /* the first static char [] must be alphabetic.  40 static char [s] maximum */

    strcpy(name,"weaponh23");

    /* x is initial guess and also holds the current solution */
    /* problem dimension n = dim(x), nh = dim(h), ng = dim(g) */

    analyt = TRUE;
    epsdif = 1.0e-16;
    del0   = 1.e1;
    tau0   = 1.e4;
    tau    = 0.1e0;
    for (i = 1 ; i <= n ; i++) {
        x[i] = xst0[i];
        low[i] = 0.0 ;
    }

    for ( i=1 ; i <=nonlin; i++ )
    {
       low[i+n] = 0.0 ;
    }


    for (i = 1 ; i <= 5 ; i++) {
        for (j = 1 ; j <= 20 ; j++) {
            wd[(i-1)*20+j] = log(wa[i][j]);
        }
    }
    nreset = n;
    
    


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

    static DOUBLE  sum,prod;
    static INTEGER i,j,k,ind;

    sum = 0.e0;
    for (j = 1 ; j <= 20 ; j++) {
        prod = 0.e0;
        k    = j-20;
        for (i = 1 ; i <= 5 ; i++) {
            ind  = i*20+k;
            prod = prod+x[ind]*wd[ind];
        }
        prod = exp(prod)-1.e0;
        sum  = sum+wu[j]*prod;
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

    static DOUBLE  sum;
    static INTEGER i,j,k,ind;


    for (j = 1 ; j <= 20 ; j++) {
        sum = 0.e0;
        k   = j-20;
        for (i = 1 ; i <= 5 ; i++) {
            ind = i*20+k;
            sum = sum+x[ind]*wd[ind];
        }
        for (i = 1 ; i <= 5 ; i++) {
            ind        = i*20+k;
            gradf[ind] = wu[j]*wd[ind]*exp(sum);
        }
    }
    return;
}

/* **************************************************************************** */
/*              compute the i-th inequality constaint, bounds included          */
/* **************************************************************************** */
void econ(INTEGER type ,INTEGER liste[], DOUBLE x[],DOUBLE con[], 
              LOGICAL err[]) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X
    
    static DOUBLE  sum;
    static INTEGER i,i1,i2,j;
    for (  i=8;  i<=12; i++) 
    {
        sum = 0.e0;
        i1  = i-7;
        i2  = (i1-1)*20;
        for (j = 1 ; j <= 20 ; j++) {
            sum = sum+x[i2+j];
        }
        con[i] = -sum+wc[i1];
    }
    for ( i=1; i<=7; i++ )
    {
        sum = 0.e0;
        for (j = 1 ; j <= 5 ; j++) {
            sum = sum+x[(j-1)*20+wj[i]];
        }
        con[i] = sum-wb[i];
    }
    return;
}

/* **************************************************************************** */
/*              compute the gradient of the nonlinear constraints               */
/* **************************************************************************** */
void econgrad(INTEGER liste[] ,INTEGER shift ,  DOUBLE x[],
               DOUBLE **grad) {

    #define  X extern
    #include "o8fuco.h"
    #undef   X

    static INTEGER i,j,i1,i2;
    /* we evaluate all, even if not required */
    for ( i=1; i<=12; i++ ) 
    {    
      for ( j = 1 ;  j <= n;  j++) 
      {
        grad[j][i+shift] = 0.e0;
      }
    }
    for ( i=1; i<=7; i++) {
        for (j = 1 ; j <= 5 ; j++) {
            grad[(j-1)*20+wj[i]][i+shift] = 1.e0;
        }
    } 
    for ( i=8; i<=12; i++){
        i1 = i-7;
        i2 = (i1-1)*20;
        for (j = 1 ; j <= 20 ; j++) {
            grad[i2+j][i+shift] = -1.e0;
        }
    }
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

