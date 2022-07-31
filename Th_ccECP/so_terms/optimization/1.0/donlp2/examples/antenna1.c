/* **************************************************************************** */
/*                                 user functions                               */
/* **************************************************************************** */
#include "o8para.h"

main() {
    void donlp2(void);
    
    donlp2();
    
    exit(0);
}

static DOUBLE length,dist,pi;
static DOUBLE thetaw[164];
static INTEGER nlh =163;
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
    
    n      = 7;
    nlin   =  5;
    nonlin =  2*nlh;
    iterma = 4000;
    nstep = 20;
}


void user_init(void) {
    #define  X extern
    #include "o8comm.h"
    
    /* #include "o8fint.h" */
    
    #undef   X
    
    static INTEGER i,j;
    

    del0   = 0.01e0;
    tau0   = 1.e3;
    tau    = 0.1e0;
    strcpy(name,"antenna1");
    length = 3.5e0;
    dist   = 0.4e0;
    pi     = 4.e0*atan(1.e0);
    x[1]   = 10.e0;
    for (i = 2 ; i <= 7 ; i++) {
        x[i] = (DOUBLE)(i-1)*length/7.e0;
    }
    for (j = 1 ; j <= 163 ; j++) {
        thetaw[j] = pi*(8.5e0+(DOUBLE)j*0.5e0)/180.e0;
    }
    analyt = TRUE;
    epsdif = 1.e-8;
    low[1] = -1.0e20;  up[1]= 1.0e20;
    low[2] = dist ; up[2] = length; 
    for ( i=3; i<=7; i++ )
    {
      low[i] = dist; up[i] = length ;
    }
    up[7] = length-dist;
    for ( i = n+1; i<=n+nlin; i++)
    {
      low[i] = dist;  up[i] = length;
    }
    for ( i=n+nlin+1; i<=n+nlin+nonlin; i++ )
    {
       low[i] = 0.0; up[i] =1.0e20;
    }
    /* x[j+1]-x[j] >= dist, j=2,..,6 */
    for ( i=1; i<=nlin; i++)
    {
      for ( j=1; j<=n; j++ )
      {
        gres[j][i] = 0.0 ;
      }
      gres[i+1][i] = -1.0;
      gres[i+2][i] = 1.0;
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

  
    *fx = x[1];
    
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


    gradf[1] = 1.e0;
    for (i = 2 ; i <= n ; i++) {
        gradf[i] = 0.e0;
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
    
    static INTEGER j,k;
    static DOUBLE  cj,fac;
    /* we compute them all , irrespective of type */
    for ( j=1; j<=nlh; j++)
    {
        fac = 2.e0*pi*sin(thetaw[j]);
        cj  = 0.5e0+cos(length*fac);
        for (k = 1 ; k <= 6 ; k++) {
            cj = cj+cos(fac*x[k+1]);
        }
        cj   = cj*2.e0/15.e0;
        con[j] = x[1]-cj;
        con[j+nlh] = cj+x[1] ;
    }
        return;
        
}

/* **************************************************************************** */
/*              compute the gradient of the i-th inequality constraint          */
/*          not necessary for bounds, but constant gradients must be set        */
/*                      here e.g. using dcopy from a data-field                 */
/* **************************************************************************** */
void econgrad(INTEGER liste[] ,INTEGER shift ,  DOUBLE x[],
               DOUBLE **grad) {

    #define  X extern
    #include "o8fuco.h"
    #undef   X

    static DOUBLE  fac;
    static INTEGER i,j,k;
    
    for ( i=1; i<=nonlin; i++) {
       grad[1][i+shift] = 1.0 ;
    }
    for ( j=1; j<=nlh; j++)
    {
        fac       = 2.e0*pi*sin(thetaw[j]);
        for (k = 2 ; k <= 7 ; k++) {
            grad[k][j+shift] = (2.e0/15.e0)*fac*sin(fac*x[k]);
            grad[k][j+nlh+shift] = -grad[k][j+shift] ;
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

