/* **************************************************************************** */
/*                                 user functions                               */
/* **************************************************************************** */
#include "o8para.h"
    
    static DOUBLE y[] = {0., /* not used : index 0 */
         .475e0,
         .525e0,
         .550e0,.550e0,.550e0,.550e0,
         .575e0,.575e0,.575e0,.575e0,
         .600e0,.600e0,.600e0,.600e0,.600e0,.600e0,.600e0,.600e0,.600e0,.600e0,
         .600e0,.600e0,.600e0,.600e0,.600e0,
         .625e0,.625e0,.625e0,.625e0,.625e0,.625e0,.625e0,.625e0,.625e0,.625e0,
         .625e0,.625e0,.625e0,.625e0,.625e0,
         .650e0,.650e0,.650e0,.650e0,.650e0,.650e0,.650e0,.650e0,.650e0,.650e0,
         .650e0,.650e0,.650e0,.650e0,.650e0,
         .675e0,.675e0,.675e0,.675e0,.675e0,.675e0,.675e0,.675e0,.675e0,.675e0,
         .675e0,.675e0,.675e0,
         .700e0,.700e0,.700e0,.700e0,.700e0,.700e0,.700e0,.700e0,.700e0,.700e0,
         .700e0,.700e0,.700e0,.700e0,.700e0,.700e0,.700e0,.700e0,.700e0,.700e0,
         .700e0,
         .725e0,.725e0,.725e0,.725e0,.725e0,.725e0,.725e0,.725e0,.725e0,.725e0,
         .725e0,.725e0,
         .750e0,.750e0,.750e0,.750e0,.750e0,.750e0,.750e0,.750e0,.750e0,.750e0,
         .750e0,.750e0,.750e0,.750e0,.750e0,.750e0,.750e0,
         .775e0,.775e0,.775e0,.775e0,
         .800e0,.800e0,.800e0,.800e0,.800e0,.800e0,.800e0,.800e0,.800e0,.800e0,
         .800e0,.800e0,.800e0,.800e0,.800e0,.800e0,.800e0,.800e0,.800e0,.800e0,
         .825e0,.825e0,.825e0,.825e0,.825e0,.825e0,.825e0,.825e0,
         .850e0,.850e0,.850e0,.850e0,.850e0,.850e0,.850e0,.850e0,.850e0,.850e0,
         .850e0,.850e0,.850e0,.850e0,.850e0,.850e0,.850e0,
         .875e0,.875e0,.875e0,.875e0,.875e0,.875e0,.875e0,.875e0,
         .900e0,.900e0,.900e0,.900e0,.900e0,.900e0,
         .925e0,.925e0,.925e0,.925e0,.925e0,.925e0,
         .950e0,.950e0,.950e0,.950e0,.950e0,.950e0,.950e0,
         .975e0,.975e0,.975e0,.975e0,
         1.000e0,1.000e0,1.000e0,
         1.025e0,1.025e0,1.025e0,
         1.050e0,1.050e0,1.050e0,1.050e0,1.050e0,1.050e0,1.050e0,1.050e0,
         1.075e0,
         1.100e0,1.100e0,1.100e0,1.100e0,1.100e0,1.100e0,
         1.150e0,1.150e0,1.150e0,1.150e0,1.150e0,
         1.175e0,
         1.200e0,1.200e0,1.200e0,1.200e0,1.200e0,1.200e0,1.200e0,
         1.225e0,
         1.250e0,1.250e0 };
        
    /* in the original scaling this: */

main() {
    void donlp2(void);
    
    donlp2();
    
    exit(0);
}
/* hs105 */

/* **************************************************************************** */
/*                              donlp2 standard setup                           */
/* **************************************************************************** */
void user_init_size(void) {
    #define  X extern
    #include "o8comm.h"
    #include "o8fint.h"
    #include "o8cons.h"
    #undef   X


    /* problem dimension n = dim(x), nlin=number of linear constraints */
    n = 8 ;
    nlin = 1 ;
    nonlin = 0;
    iterma = 4000;
    nstep = 20;
}

void user_init(void) {
    #define  X extern
    #include "o8comm.h"
    #include "o8fint.h"
    #include "o8cons.h"
    #undef   X
    
    static INTEGER i,j;
    static DOUBLE ugloc[] = {0., /* not used : index 0 */
                          1.e-3,1.e-3,100.e0,130.e0,170.e0,5.e0,5.e0,5.e0 };
    static DOUBLE ogloc[] = {0., /* not used : index 0 */
                          .499e0,.499e0,180.e0,210.e0,240.e0,25.e0,25.e0,25.e0 };
    
    strcpy(name,"hs105orig");
    
    x[1] = .1e0;
    x[2] = .2e0;
    x[3] = 100.e0;
    x[4] = 125.e0;
    x[5] = 175.e0;
    x[6] = 11.2e0;
    x[7] = 13.2e0;
    x[8] = 15.8e0;
            

    del0 = 0.001e0;
    tau0 = 1.e0;
    tau  = .1e0;
    for ( i=1; i<=n; i++)
    {
      low[i] = ugloc[i]; up[i] = ogloc[i] ;  gres[i][1] = 0.0;
    }
    low[n+1] = -1.0e20; up[n+1] = 1.0;
    gres[1][1] = 1.0;
    gres[2][1] = 1.0;  /* x[1]+x[2] <= 1; */
    for (i = 1 ; i <= 235 ; i++) 
    {
       y[i] = y[i]*200.e0;
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

    static DOUBLE  term,a,b,c,arg,s;
    static INTEGER i;
    static DOUBLE  sqrt2pi = 2.50662827463100050240e0;

    icf = icf+1;
    s   = 0.e0;
    for (i = 1 ; i <= 235 ; i++) {
        term = -pow(y[i]-x[3],2)/(2.e0*pow(x[6],2));
        if ( term <= -200.e0 ) {
            a = 0.e0;
        } else {
            a = exp(term)*x[1]/x[6];
        }
        term = -pow(y[i]-x[4],2)/(2.e0*pow(x[7],2));
        if ( term <= -200.e0 ) {
            b = 0.e0;
        } else {
            b = exp(term)*x[2]/x[7];
        }
        term = -pow(y[i]-x[5],2)/(2.e0*pow(x[8],2));
        if(term <= -200.e0) {
            c = 0.e0;
        } else {
            c = (1.e0-x[1]-x[2])/x[8]*exp(term);
        }
        arg = fabs(a+b+c);
    
        /* due to the bounds imposed, this should never change arg */
    
        s = s-log(arg/sqrt2pi);
    }
    *fx = s;
    
    return;
}

/* **************************************************************************** */
/*                          gradient of objective function                      */
/* **************************************************************************** */
void egradf(DOUBLE x[],DOUBLE gradf[]) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X

    static INTEGER i;
    static DOUBLE  g[9],d;
    static DOUBLE  x1,x2,x3,x4,x5,x6,x7,x8,yi,t1,t2,t3,a,b,c;
    static DOUBLE  term;

    icgf = icgf+1;
    for (i = 1 ; i <= 8 ; i++) {
        g[i] = 0.e0;
    }
    x1 = x[1];
    x2 = x[2];
    x3 = x[3];
    x4 = x[4];
    x5 = x[5];
    x6 = x[6];
    x7 = x[7];
    x8 = x[8];
    for (i = 1 ; i <= 235 ; i++) {
        yi = y[i];
        t1 = pow(yi-x3,2)/(2.e0*pow(x6,2));
        a  = 0.e0;
        if ( t1 < 200.e0 ) a = exp(-t1);
        t2 = pow(yi-x4,2)/(2.e0*pow(x7,2));
        b = 0.e0;
        if(  t2 < 200.e0 ) b = exp(-t2);
        t3 = pow(yi-x5,2)/(2.e0*pow(x8,2));
        c  = 0.e0;
        if ( t3 < 200.e0 ) c = exp(-t3);
        d  = 1.e0/(x1*a/x6+x2*b/x7+(1.e0-x1-x2)/x8*c);
    
        g[1] = g[1]-d* (a/x6 - c/x8);
        g[2] = g[2]-d* (b/x7 - c/x8);
        g[3] = g[3]-d* (x1*a*(yi-x3)/pow(x6,3));
        g[4] = g[4]-d* (x2*b*(yi-x4)/pow(x7,3));
        g[5] = g[5]-d* (1.e0-x1-x2)*c*(yi-x5)/pow(x8,3) ;
        g[6] = g[6]-d* x1*a/pow(x6,2)*(-1.e0 +2.e0*t1);
        g[7] = g[7]-d* x2*b/pow(x7,2)*(-1.e0 +2.e0*t2);
        g[8] = g[8]-d* (1.e0-x1-x2)*c/pow(x8,2)*(-1.e0 +2.e0*t3);
    }

    for (i = 1 ; i <= 8 ; i++) {
        gradf[i] = g[i];
    }
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

