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


    /* problem dimension n = dim(x), nlin=number of linear constraints
       nonlin = number of nonlinear constraints  */
    
    n      = 9;
    nlin   =  0;
    nonlin =  5;
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

    /* dembo4c */

    strcpy(name,"dembo4c");
     
    x[1] = 6.e0;
    x[2] = 3.e0;
    x[3] =  .4e0;
    x[4] =  .2e0;
    x[5] = 6.e0;
    x[6] = 6.e0;
    x[7] = 1.e0;
    x[8] =  .5e0;
    x[9] = 4.2e0;


    del0 = 1.0e0;
    tau0 = 1.0e0;
    tau  =  .1e0;
    for ( i=1; i<=n; i++)
    {
      low[i] = 0.1 ; up[i] = 10.0 ;
    }
    for ( i=1; i<=n+nlin+nonlin; i++)
    {
      low[i] = 0.0; up[i] = 1.0e20;
    }

    analyt = TRUE;
    epsdif = 1.0e-16;
    nreset = n;
    silent = FALSE;
    
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
    

    *fx = x[9];
    
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
    

    gradf[9] = 1.e0;
    for (i = 1 ; i <= 8 ; i++) {
        gradf[i] = 0.e0;
    }
    return;
}

/* **************************************************************************** */
/*              compute the  inequality constaints                              */
/* **************************************************************************** */
void econ(INTEGER type ,INTEGER liste[], DOUBLE x[],DOUBLE con[], 
              LOGICAL err[]) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X

    
    void fgeo(DOUBLE x[],DOUBLE con,DOUBLE gam[],LOGICAL lin,DOUBLE dl[],void *pk,
              void *pal,INTEGER nlen,INTEGER nanz,INTEGER nx,DOUBLE *fx);
    
    static DOUBLE dl[10],gxi;
    static INTEGER i;
    
    static DOUBLE gam1[] = { 0., /* not used : index 0 */
                            -4.e0,-2.e0,-.0588e0 };

    static DOUBLE al1[][4] = {
            {0.e0,       0.e0,  0.e0  , 0.e0 },
             
            {0.e0,       1.e0, - .71e0,-1.3e0},
            {0.e0,      -1.e0, -1.e0  , 1.e0 } };
    
    static INTEGER k1[][4] = {
            {0,      0,0,0},
            
            {0,      3,3,3},
            {0,      5,5,7} };
    
    static INTEGER k2[][4] = {
            {0,      0,0,0},
            
            {0,      4,4,4},
            {0,      6,6,8} };

    static INTEGER k5[][4] = {
            {0,      0, 0, 0},
            
            {0,      1, 1, 1},
            {0,      2, 2, 2},
            {0,      7, 8, 0},
            {0,      9, 9, 9} };

    static DOUBLE al5[][4] = {
            {0.e0,       0.e0  , 0.e0   , 0.e0},
             
            {0.e0,       .168e0, -.502e0, -.502e0},
            {0.e0,      -.185e0,  .485e0, -.185e0},
            {0.e0,      -.67e0 , -.67e0 , 0.e0   },
            {0.e0,      -.313e0, -.313e0, -.313e0} };

    static DOUBLE gam5[] = { 0., /* not used : index 0 */
                            -.144e0,-.144e0,-3.6e0 };
    
    for ( i=1; i<=5; i++)
    {    
      switch(i) 
      {
      case 1:
        gxi = 1.e0-.0588e0*x[5]*x[7]-.1e0* x[1];
        
        break;
        
      case 2:
        gxi = 1.e0-.0588e0*x[6]*x[8]-.1e0*(x[1]+x[2]);
        
        break;
        
      case 3:
        fgeo(x,1.e0,gam1,FALSE,dl,k1,al1,2,3,9,&gxi);
        
        break;
        
      case 4:
        fgeo(x,1.e0,gam1,FALSE,dl,k2,al1,2,3,9,&gxi);
        
        break;
        
      case 5:
        fgeo(x, 1.e0,gam5,FALSE,dl,k5,al5,4,3,9,&gxi);
        
        break;
      }
    con[i] = gxi ;
  }    
  return;
}

/* **************************************************************************** */
/*              compute the gradient of the  inequality constraints             */
/* **************************************************************************** */
void econgrad(INTEGER liste[] ,INTEGER shift ,  DOUBLE x[],
               DOUBLE **grad) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X

    
    void dfgeo(DOUBLE x[],DOUBLE gam[],LOGICAL lin,DOUBLE dl[],void *pk,
               void *pal,INTEGER nlen,INTEGER nanz,DOUBLE g[],INTEGER nx);
    
    static INTEGER i,j;
    static DOUBLE  dl[10],gradgi[10];
    
    static DOUBLE gam1[] = { 0., /* not used : index 0 */
                            -4.e0,-2.e0,-.0588e0 };

    static DOUBLE al1[][4] = {
            {0.e0,       0.e0,  0.e0  , 0.e0 },
             
            {0.e0,       1.e0, - .71e0,-1.3e0},
            {0.e0,      -1.e0, -1.e0  , 1.e0 } };
    
    static INTEGER k1[][4] = {
            {0,      0,0,0},
            
            {0,      3,3,3},
            {0,      5,5,7} };
    
    static INTEGER k2[][4] = {
            {0,      0,0,0},
            
            {0,      4,4,4},
            {0,      6,6,8} };

    static INTEGER k5[][4] = {
            {0,      0, 0, 0},
            
            {0,      1, 1, 1},
            {0,      2, 2, 2},
            {0,      7, 8, 0},
            {0,      9, 9, 9} };

    static DOUBLE al5[][4] = {
            {0.e0,       0.e0  , 0.e0   , 0.e0},
             
            {0.e0,       .168e0, -.502e0, -.502e0},
            {0.e0,      -.185e0,  .485e0, -.185e0},
            {0.e0,      -.67e0 , -.67e0 , 0.e0   },
            {0.e0,      -.313e0, -.313e0, -.313e0} };

    static DOUBLE gam5[] = { 0., /* not used : index 0 */
                            -.144e0,-.144e0,-3.6e0 };

  for ( i=1; i<=5; i++)
  {    
    for (j = 1 ; j <= 9 ; j++) {
        gradgi[j] = 0.e0;
    }
    switch (i) {
    case 1:
        gradgi[1] = -.1e0;
        gradgi[5] = -.0588e0*x[7];
        gradgi[7] = -.0588e0*x[5];
        
        break;
        
    case 2:
        gradgi[1] = -.1e0;
        gradgi[2] = -.1e0;
        gradgi[6] = -.0588e0*x[8];
        gradgi[8] = -.0588e0*x[6];
        
        break;
        
    case 3:
        dfgeo(x,gam1,FALSE,dl,k1,al1,2,3,gradgi,9);
        
        break;
        
    case 4:
        dfgeo(x,gam1,FALSE,dl,k2,al1,2,3,gradgi,9);
        
        break;
        
    case 5:
        dfgeo(x,gam5,FALSE,dl,k5,al5,4,3,gradgi,9);
        
        break;
    }
    for ( j=1; j<=9; j++)
    {
      grad[j][i] = gradgi[j];
    }
  }
  return;
}

/* **************************************************************************** */
/* evalution of a function of a geometric programming problem described by      */
/* the model                                                                    */
/* fx  =  con + sum{i=1,nx} x[i]*dl[i]                                          */
/*            + sum{i=1,nanz} (gam[i]*(prod{j=1,nlen}pow(x[k[j][i]],al[j][i]))  */
/* if lin  =  FALSE dl may be undefined                                         */
/* **************************************************************************** */
void fgeo(DOUBLE x[],DOUBLE con,DOUBLE gam[],LOGICAL lin,DOUBLE dl[],void *pk,
          void *pal,INTEGER nlen,INTEGER nanz,INTEGER nx,DOUBLE *fx) {
          
    static INTEGER i,j,il,*k;
    static DOUBLE  s,p,expo,*al;
    
    k  = pk;
    al = pal;
    
    s = con;
    
    if ( ! lin ) goto L200;
    
    for (i = 1 ; i <= nx ; i++) {
        s = s+dl[i]*x[i];
    }
    L200 :
  
    for (i = 1 ; i <= nanz ; i++) {
    
        if ( gam[i] == 0.e0 ) goto L600;
        
        p = 1.e0;
        for (j = 1 ; j <= nlen ; j++) {
            il = k[j*(nanz+1)+i];           /* il = k[j][i]; */
    
            if ( il == 0 ) goto L500;
    
            expo = al[j*(nanz+1)+i];        /* expo = al[j][i]; */
    
            if ( expo == 0.e0 ) goto L500;
    
            p = p*exp(expo*log(fabs(x[il])));
    
            L500:;
        }

        s = s+gam[i]*p;
    
        L600:;
    }

    *fx = s;
    
    return;
}

/* **************************************************************************** */
/*          computation of the gradient of a function given by fgeo above       */
/* **************************************************************************** */
void dfgeo(DOUBLE x[],DOUBLE gam[],LOGICAL lin,DOUBLE dl[],void *pk,
           void *pal,INTEGER nlen,INTEGER nanz,DOUBLE g[],INTEGER nx) {
           
    static INTEGER i,j,il,l,*k;
    static DOUBLE  s,p,fc,expo,fij,*al;
    
    k  = pk;
    al = pal;
    
    for (l = 1 ; l <= nx ; l++) {
        s = 0.e0;
        for (i = 1 ; i <= nanz ; i++) {
        
            if ( gam[i] == 0.e0 ) goto L400;
            
            p  = 1.e0;
            fc = 0.e0;
            for (j = 1 ; j <= nlen ; j++) {
                il = k[j*(nanz+1)+i];           /* il = k[j][i]; */
                if( il == 0 ) goto L300;
                if( il != l ) goto L100;
                fc = 1.e0;
                
                L100:

                expo = al[j*(nanz+1)+i];        /* expo = al[j][i]; */
                if ( expo == 0.e0 ) goto L300;
                fij = 1.e0;
                if ( il != l ) goto L200;
                fij  = expo;
                expo = expo-1.e0;
                
                L200:

                p = p*fij*exp(expo*log(fabs(x[il])));
                
                L300:;
            }
            if ( fc != 0.e0 ) s = s+p*gam[i];
                
            L400:;
        }
        if ( lin ) s = s+dl[l];
        g[l] = s;
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

