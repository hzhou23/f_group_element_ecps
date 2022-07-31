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
/*                              donlp2 standard setup                           */
/* **************************************************************************** */
void user_init_size(void) {
    #define  X extern
    #include "o8comm.h"
    #include "o8fint.h"
    #include "o8cons.h"
    #undef   X
    n  = 12;
    nlin = 0 ;
    nonlin = 7 ;
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

    /*  this is example Himmelblau 13, box parameter identification problem */

    void startx(DOUBLE x[]);    
    strcpy(name,"him13boxproblem");

    
    static DOUBLE xk[17] = {0.,/* not used : index 0 */
            0.e0,1.2e0,20.0e0,9.e0 , 6.5e0,  0.e0,  0.e0,  0.e0,
            5.e0,2.4e0, 6.e1 ,9.3e0, 7.0e0,294.e3,294.e3,277.2e3};
    
    del0 = 0.1e0;
    tau0 = 1.0e0;
    tau  =  .1e0;
    epsfcn = 1.0e-15 ;
    epsdif = 1.0e-16;
    analyt = TRUE ;
        
    x[1] = 2.52e0;
    x[2] = 2.e0;
    x[3] = 37.5e0;
    x[4] = 9.25e0;
    x[5] = 6.8e0;
    
    for (i = 6 ; i <= n ; i++) {
        x[i] = 0.0e0;
    }
    startx(x);
    for ( i=1; i<=8; i++)
    {
      low[i] = xk[i]; up[i] = xk[i+8];
    }
    for ( i=9; i<=n; i++)
    {
      low[i] = -1.0e20; up[i] = 1.0e20 ;
    }
    for ( i=n+1; i<=n+nonlin; i++ )
    {
       low[i] = up[i] = 0.0 ; /* 7 nonlinear equality constraints */
    }


    return;
}

void startx(DOUBLE x[]) {
    static INTEGER  i;
    static DOUBLE   xk[31] = {0.,/* not used : index 0 */
            -145.421402e3 ,   2.9311506e3,-40.427932e0  ,  5.106192e3,
              15.711360e3 ,-161.622577e3 ,  4.17615328e3,  2.8260078e0,
               9.200476e3 ,  13.160295e3 ,-21.6869194e3 ,123.56928e0,
             -21.1188894e0, 706.834000e0 ,  2.8985730e3 , 28.298388e3,
              60.8109600e0,  31.242116e0 ,329.5740000e0 , -2.882082e3,
              74.0953845e3, -30.6262544e1, 16.2436490e0 , -3.094252e3,
             - 5.5662628e3, -26.237000e3 , 99.e0        , -0.42e0,  
               1.3e3      ,   2.1e3};
            
    x[6] = xk[1];
    for ( i = 2 ; i <= 5 ; i++) {
        x[6] = x[6]+xk[i]*x[i];
    }
    x[6] = x[6]*x[1];
    x[9] = xk[6];
    for ( i = 2 ; i <= 5 ; i++) {
        x[9] = x[9]+xk[i+5]*x[i];
    }
    x[10] = xk[11];
    for ( i = 2 ; i <= 5 ; i++) {
        x[10] = x[10]+xk[i+10]*x[i];
    }
    x[11] = xk[16];
    for ( i = 2 ; i <= 5 ; i++) {
        x[11] = x[11]+xk[i+15]*x[i];
    }
    x[12] = xk[21];
    for ( i = 2 ; i <= 5 ; i++) {
        x[12] = x[12]+xk[i+20]*x[i];
    }
    x[7] = (x[9]+x[10]+x[11])*x[1];
    x[8] = xk[26];
    for ( i = 2 ; i <= 5 ; i++) {
        x[8] = x[8]+xk[i+25]*x[i];
    }
    x[8] = x[8]*x[1]+x[6]+x[7];
    
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

    static DOUBLE xk[6] ={0.,/* not used : index 0 */
    925.548252e3,-61.9688432e3,23.3088196e0,-27.097648e3,-50.843766e3};
    

    
    *fx = -(50.e0*x[9]+9.583e0*x[10]+20.e0*x[11]+15.e0*x[12]-
             852.96e3-38.1e3*(x[2]+0.01e0*x[3]) +xk[1]+xk[2]*x[2]+
             xk[3]*x[3]+xk[4]*x[4]+xk[5]*x[5])*x[1]-15.e0*x[6];
    
    return;
}

/* **************************************************************************** */
/*                          gradient of objective function                      */
/* **************************************************************************** */
void egradf(DOUBLE x[],DOUBLE gradf[]) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X

    static DOUBLE xk[6] = {0.,/* not used : index 0 */
    925.548252e3,-61.9688432e3,23.3088196e0,-27.097648e3,-50.843766e3};
    
    
    gradf[1]  = -(50.e0*x[9]+9.583e0*x[10]+20.e0*x[11]+15.e0*x[12]-
                852.96e3-38.1e3*(x[2]+0.01e0*x[3]) +xk[1]+xk[2]*x[2]+
                xk[3]*x[3]+xk[4]*x[4]+xk[5]*x[5]);
    gradf[2]  = 38.1e3*x[1]-xk[2]*x[1];
    gradf[3]  = -xk[3]*x[1] +.381e3*x[1];
    gradf[4]  = -xk[4]*x[1];
    gradf[5]  = -xk[5]*x[1];
    gradf[6]  = -15.e0;
    gradf[7]  =  0.0e0;
    gradf[8]  =  0.0e0;
    gradf[9]  = -x[1]*50.e0;
    gradf[10] = -x[1]*9.583e0;
    gradf[11] = -x[1]*20.e0;
    gradf[12] = -x[1]*15.e0;
    
    return;
}

/* **************************************************************************** */
/*                compute the i-th equality constaint, value is hxi             */
/* **************************************************************************** */
void econ(INTEGER type ,INTEGER liste[], DOUBLE x[],DOUBLE con[], 
              LOGICAL err[]) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X
    static INTEGER i,j;
    
    static INTEGER k,ii,iik;
    static DOUBLE term, xk[31] = {0.,/* not used : index 0 */
            -145.421402e3 ,   2.9311506e3,-40.427932e0  ,  5.106192e3,
              15.711360e3 ,-161.622577e3 ,  4.17615328e3,  2.8260078e0,
               9.200476e3 ,  13.160295e3 ,-21.6869194e3 ,123.56928e0,
             -21.1188894e0, 706.834000e0 ,  2.8985730e3 , 28.298388e3,
              60.8109600e0,  31.242116e0 ,329.5740000e0 , -2.882082e3,
              74.0953845e3, -30.6262544e1, 16.2436490e0 , -3.094252e3,
             - 5.5662628e3, -26.237000e3 , 99.e0        , -0.42e0,
               1.3e3      ,   2.1e3};
               
    for ( i=1; i<=7; i++)
    {    
      if (i != 7) 
      {
        ii   = (i-1)*5;
        term = xk[ii+1];
        for ( k = 2 ; k <= 5 ; k++) {
            iik  = ii+k;
            term += xk[iik]*x[k];
        }
        switch (i) 
        {
        case 1:
            con[1] = x[6]-term*x[1];
            break;
        case 2:
        case 3:
        case 4:
        case 5:
            con[i] = x[i+7]-term;
            break;
        case 6:
            con[6] = x[8]-(term*x[1]+x[6]+x[7]);
            break;
        }
      } 
      else 
      {
        con[7] = x[7]-(x[9]+x[10]+x[11])*x[1];
      }
    }
    return;
}

/* **************************************************************************** */
/*              compute the gradient of the i-th equality constraint            */
/* **************************************************************************** */
void econgrad(INTEGER liste[] ,INTEGER shift ,  DOUBLE x[],
               DOUBLE **grad) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X


    static INTEGER  i,k,ii,iik;
    static DOUBLE   xk[31] = {0.,/* not used : index 0 */
            -145.421402e3 ,   2.9311506e3,-40.427932e0  ,  5.106192e3,
              15.711360e3 ,-161.622577e3 ,  4.17615328e3,  2.8260078e0,
               9.200476e3 ,  13.160295e3 ,-21.6869194e3 ,123.56928e0,
             -21.1188894e0, 706.834000e0 ,  2.8985730e3 , 28.298388e3,
              60.8109600e0,  31.242116e0 ,329.5740000e0 , -2.882082e3,
              74.0953845e3, -30.6262544e1, 16.2436490e0 , -3.094252e3,
              -5.5662628e3, -26.237000e3 , 99.e0        , -0.42e0,
               1.3e3      ,   2.1e3};
               
    for ( i=1; i<=7; i++)
    {
      for ( k = 1 ; k <= 12 ; k++) 
      {
        grad[k][i+shift] = 0.e0;
      }
    }
    for ( i=1; i<=7; i++)
    {

       switch (i) 
       {
        case 1:
        case 6:
        ii = (i-1)*5;
        grad[1][i+shift] = -(xk[ii+1]+xk[ii+2]*x[2]+xk[ii+3]*x[3]+xk[ii+4]*x[4]
                    +xk[ii+5]*x[5]);
        for ( k = 2 ; k <= 5 ; k++) {
            iik       = ii+k;
            grad[k][i+shift] = -xk[iik]*x[1];
        }
        if (i == 6) {
            grad[6][i+shift] = -1.e0;
            grad[7][i+shift] = -1.e0;
            grad[8][i+shift] =  1.e0;
        } else {
            grad[6][i+shift] = 1.e0;
        }
        break;
        case 2:
        case 3:
        case 4:
        case 5:
        ii = (i-1)*5;
        for ( k = 2 ; k <= 5 ; k++) {
            iik = ii+k;
            grad[k][i+shift] = -xk[iik];
        }
        grad[i+7][i+shift] = 1.e0;
        break;
        case 7:
        grad[ 1][i+shift] = -(x[9]+x[10] +x[11]);
        grad[ 7][i+shift] =  1.e0;
        grad[ 9][i+shift] = -x[1];
        grad[10][i+shift] = -x[1];
        grad[11][i+shift] = -x[1];
        break;
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

