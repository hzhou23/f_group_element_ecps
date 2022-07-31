/* **************************************************************************** */
/*                                 user functions                               */
/* **************************************************************************** */
#include "o8para.h"

main() {
    void donlp2(void);
    
    donlp2();
    
    exit(0);
}
/* Himmelblau 6 with corrections by Murtagh and Sargent */

/* **************************************************************************** */
/*                              donlp2 standard setup                           */
/* **************************************************************************** */
void user_init_size(void) {
    #define  X extern
    #include "o8comm.h"
    #include "o8fint.h"
    #include "o8cons.h"
    #undef   X

     n=45;
     nlin=16;
     nonlin=0;
     iterma = 4000;
     nstep = 20;
}


void user_init(void) {
    #define  X extern
    #include "o8comm.h"
    #include "o8cons.h"
    #undef   X
     
    static INTEGER i,j;
    DOUBLE ccons[]={ 0.0 /*not used*/, 0.6529581e0, 0.281941e0, 3.705233e0,
                47.00022e0, 47.02972e0, 0.08005e0, 0.08813e0, 0.04829e0,
               0.0155e0, 0.0211275e0,0.0022725e0, 0.0, 0.0, 0.0,0.0,0.0};

    for (i = 1 ; i <= n ; i++) {
        xst[i] = 0.1e0;
        x[i]   = xst[i];
    }
    strcpy(name,"himblau6");
    

    del0 = 1.e-5;
    tau0 = 1.e4;
    tau  = 0.1;
    for ( i=1; i<=n; i++)
    {
      low[i] = 1.0e-6; up[i] = 1.0e20;
    }
    for ( i=n+1; i<=n+nlin; i++)
    {
      low[i] = up [i] = ccons[i-n] ;
    }
    for ( i=1; i<=nlin; i++)
    {
      for (j=1; j<=n;  j++)
      {
        gres[j][i] = 0.0 ;
      }
    }
    for ( i=1; i<=nlin; i++)
    {

      switch (i) 
      {
        case 1:
        gres[ 1][i] =  1.e0;
        gres[ 5][i] =  1.e0;
        gres[18][i] =  1.e0;
        gres[32][i] =  1.e0;
        gres[33][i] =  2.e0;
        gres[34][i] =  3.e0;
        gres[35][i] =  4.e0;
        
        break;
        
        case 2:
        gres[ 2][i] =  1.e0;
        gres[ 6][i] =  1.e0;
        gres[14][i] =  1.e0;
        gres[15][i] =  1.e0;
        gres[16][i] =  1.e0;
        gres[19][i] =  1.e0;
        gres[27][i] =  1.e0;
        gres[28][i] =  1.e0;
        gres[29][i] =  1.e0;
        gres[43][i] =  1.e0;
        gres[45][i] =  1.e0;
        
        break;
        
        case 3:
        gres[ 3][i] =  1.e0;
        gres[ 7][i] =  1.e0;
        gres[20][i] =  1.e0;
        
        break;
        
        case 4:
        gres[ 4][i] =  1.e0;
        gres[ 8][i] =  1.e0;
        gres[13][i] =  1.e0;
        gres[15][i] =  1.e0;
        gres[16][i] = -1.e0;
        gres[21][i] =  1.e0;
        gres[26][i] =  1.e0;
        gres[28][i] =  1.e0;
        gres[29][i] = -1.e0;
        gres[36][i] =  1.e0;
        gres[38][i] = -1.e0;
        gres[39][i] =  1.e0;
        gres[41][i] = -1.e0;
        gres[43][i] = -1.e0;
        gres[45][i] = -1.e0;
        
        break;
        
        case 5:
        gres[ 4][i] =  1.e0;
        gres[ 9][i] =  1.e0;
        gres[13][i] =  1.e0;
        gres[14][i] =  1.e0;
        gres[15][i] =  1.e0;
        gres[16][i] =  1.e0;
        gres[22][i] =  1.e0;
        gres[26][i] =  1.e0;
        gres[27][i] =  1.e0;
        gres[28][i] =  1.e0;
        gres[29][i] =  1.e0;
        
        break;
        
        case 6:
        gres[10][i] =  1.e0;
        gres[23][i] =  1.e0;
        
        break;
        
        case 7:
        gres[11][i] =  1.e0;
        gres[24][i] =  1.e0;
        
        break;
        
        case 8:
        gres[12][i] =  1.e0;
        gres[25][i] =  1.e0;
        
        break;
        
        case 9:
        gres[17][i] =  1.e0;
        
        break;
        
        case 10:
        gres[30][i] =  1.e0;
        
        break;
        
        case 11:
        gres[31][i] =  1.e0;
        gres[32][i] =  1.e0;
        gres[33][i] =  1.e0;
        gres[34][i] =  1.e0;
        gres[35][i] =  1.e0;
        
        break;
        
        case 12:
        gres[ 8][i] =  1.e0;
        gres[ 9][i] = -1.e0;
        gres[10][i] = -1.e0;
        gres[11][i] =  1.e0;
        gres[12][i] =  1.e0;
        gres[14][i] = -1.e0;
        gres[16][i] = -2.e0;
        gres[17][i] = -1.e0;
        
        break;
        
        case 13:
        gres[31][i] = -4.e0;
        gres[32][i] = -3.e0;
        gres[33][i] = -2.e0;
        gres[34][i] = -1.e0;
        gres[36][i] =  1.e0;
        gres[37][i] =  1.e0;
        gres[38][i] =  1.e0;
        
        break;
        
        case 14:
        gres[32][i] = -1.e0;
        gres[33][i] = -2.e0;
        gres[34][i] = -3.e0;
        gres[35][i] = -4.e0;
        gres[39][i] =  1.e0;
        gres[40][i] =  1.e0;
        gres[41][i] =  1.e0;
        
        break;
        
        case 15:
        gres[38][i] = -4.e0;
        gres[42][i] =  1.e0;
        gres[43][i] =  1.e0;
        
        break;
        
        case 16:
        gres[41][i] = -4.e0;
        gres[44][i] =  1.e0;
        gres[45][i] =  1.e0;
        
        break;
      }



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

    static INTEGER i,n1,n2,k,j;
    static DOUBLE  s1,s2;
    static DOUBLE  xa[46];
    
    static INTEGER  nk[] = { 0,  /* not used : index 0 */
                            4,17,35,38,41,43,45};
    
    static DOUBLE  c[]  = { 0,  /* not used : index 0 */
           0.e0    , -7.69e0   ,-11.52e0  ,-36.6e0    ,-10.94e0  ,  0.e0    ,
           0.e0    ,  0.e0     ,  0.e0    ,  0.e0     ,  0.e0    ,  2.5966e0,
         -39.39e0  ,-21.35e0   ,-32.84e0  ,  6.26e0   ,  0.e0    , 10.45e0  ,
           0.e0    , -0.5e0    ,  0.e0    ,  0.e0     ,  0.e0    ,  2.2435e0,
           0.e0    ,-39.39e0   ,-21.49e0  ,-32.84e0   ,  6.12e0  ,  0.e0    ,
           0.e0    , -1.9028e0 , -2.8889e0, -3.3622e0 , -7.4854e0,-15.639e0 ,
           0.e0    , 21.81e0   ,-16.79e0  ,  0.e0     , 18.9779e0,  0.e0    ,
           11.959e0,  0.e0     , 12.899e0};
           
  
    *fx = 0.e0;
    for (i = 1 ; i <= n ; i++) {
        xa[i] = fabs(x[i]);
    }
    for (i = 1 ; i <= 7 ; i++) {
        n1 = 1;
        n2 = nk[i];
        if ( i > 1 ) n1 = nk[i-1]+1;
        s1 = 0.e0;
        for (k = n1 ; k <= n2 ; k++) {
            s1 = s1+xa[k];
        }
        s2 = 0.e0;
        for (j = n1 ; j <= n2 ; j++) {
            s2 = s2+xa[j]*(c[j]+log(xa[j]/s1));
        }
        *fx = *fx+s2;
    }
    return;
}

/* **************************************************************************** */
/*                          gradient of objective function                      */
/* **************************************************************************** */
void egradf(DOUBLE x[],DOUBLE gradf[]) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X

    static INTEGER i,n1,n2,k,l,j;
    static DOUBLE  xa[46],s1;
    
    static INTEGER  nk[] = { 0,  /* not used : index 0 */
                            4,17,35,38,41,43,45};
    
    static DOUBLE  c[]  = { 0,  /* not used : index 0 */
           0.e0    , -7.69e0   ,-11.52e0  ,-36.6e0    ,-10.94e0  ,  0.e0    ,
           0.e0    ,  0.e0     ,  0.e0    ,  0.e0     ,  0.e0    ,  2.5966e0,
         -39.39e0  ,-21.35e0   ,-32.84e0  ,  6.26e0   ,  0.e0    , 10.45e0  ,
           0.e0    , -0.5e0    ,  0.e0    ,  0.e0     ,  0.e0    ,  2.2435e0,
           0.e0    ,-39.39e0   ,-21.49e0  ,-32.84e0   ,  6.12e0  ,  0.e0    ,
           0.e0    , -1.9028e0 , -2.8889e0, -3.3622e0 , -7.4854e0,-15.639e0 ,
           0.e0    , 21.81e0   ,-16.79e0  ,  0.e0     , 18.9779e0,  0.e0    ,
           11.959e0,  0.e0     , 12.899e0};

    for (i = 1 ; i <= n ; i++) {
        xa[i] = fabs(x[i]);  /* not necessary here in principle, since bounds guarantee this*/
    }
    for (k = 1 ; k <= 7 ; k++) {
        n1 = 1;
        n2 = nk[k];
        if( k > 1 ) n1 = nk[k-1]+1;
        s1 = 0.e0;
        for (l = n1 ; l <= n2 ; l++) {
            s1 = s1+xa[l];
        }
        for (j = n1 ; j <= n2 ; j++) {
            gradf[j] =  ( c[j]+log(xa[j]/s1))*x[j]/xa[j];
        }
    }
    return;
}

/* **************************************************************************** */
/*                compute nonlinear constraints                                 */
/* **************************************************************************** */
void econ(INTEGER type ,INTEGER liste[], DOUBLE x[],DOUBLE con[], 
              LOGICAL err[]) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X
    return;
}
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

