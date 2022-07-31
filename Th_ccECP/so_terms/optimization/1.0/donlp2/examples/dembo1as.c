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
    n=12;
    nlin = 0 ;
    nonlin = 3 ;
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
    static DOUBLE ugloc[] = { 0., /* not used : index 0 */
            .1e0,.1e0,.1e0,.01e0,1.e0,0.1e0,0.1e0,0.1e0,0.1e0,0.1e0,0.1e0,0.1e0 };

    static INTEGER i,j;

    /* data di[] = { 0, /* not used : index 0 */
    /*             1.e6,1.e5,1.e6,1.e9,1.e9,1.e3,1.e3,1.e3,1.e5,1.e4,   */
    /*             1.e4,1.e0,1.e0,1.e0,1.e0,1.e0,1.e0,1.e0,1.e0,1.e0,   */
    /*             1.e0,1.e0,1.e0,1.e0,1.e0,1.e0,1.e0,1.e0,1.e0,1.e0,   */
    /*             1.e0,1.e0,1.e0,1.e0,1.e0,1.e0,1.e0,1.e0,1.e0,1.e0,   */
    /*             1.e0,1.e0,1.e0,1.e0,1.e0,1.e0,1.e0,1.e0,1.e0,1.e0 }  */
    /* scaling factors for x[i], incorporated into function subprograms */
    
    /* dembo1a */

    strcpy(name,"dembo1asc");
     
    for (i = 1 ; i <= 12 ; i++) {
        x[i] = 4.e0; xsc[i] = 0.01;
    }

    del0 = 0.05e0;
    tau0 = 1.0e0;
    tau  = .1e0;
    for ( i=1; i<=n; i++)
    {
      low[i]=ugloc[i]; up[i] = 1.0e20;
    }
    for ( i=n+1; i<=n+nlin+nonlin; i++)
    {
      low[i] = 0.0 ; up[i] = 1.0e20;
    }

    analyt = TRUE;
    epsdif = 1.0e-16;
    silent = FALSE;
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
    epsx = 1.0e-7;
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
    
    void fgeo(DOUBLE x[],DOUBLE con,DOUBLE gam[],LOGICAL lin,DOUBLE dl[],void *pk,
              void *pal,INTEGER nlen,INTEGER nanz,INTEGER nx,DOUBLE *fx);

    static DOUBLE  dl[14];
    
    static INTEGER kf[][2] = {  {0,     0}, /* not used : indexes 0,0 */
    
                                {0,     1},
                                {0,     2},
                                {0,     3},
                                {0,     4},
                                {0,     5},
                                {0,     6},
                                {0,     7},
                                {0,     8},
                                {0,     9},
                                {0,    10},
                                {0,    11} };
                               
    static DOUBLE gamf[] = {0,  1.e5};

    static DOUBLE alf[][2] = {  {0,  0            }, /* not used : indexes 0,0 */
    
                                {0, -0.001331720e0},
                                {0, -0.002270927e0},
                                {0, -0.00248546e0 },
                                {0, -4.67e0       },
                                {0, -4.671973e0   },
                                {0, -0.00814e0    },
                                {0, -0.008092e0   },
                                {0,  -.005e0      },
                                {0,  -.000909e0   },
                                {0, -0.00088e0    },
                                {0, -0.00119e0    } };
   
    
    fgeo(x,0.e0,gamf,FALSE,dl,kf,alf,11,1,12,fx);
    
    return;
}

/* **************************************************************************** */
/*                          gradient of objective function                      */
/* **************************************************************************** */
void egradf(DOUBLE x[],DOUBLE gradf[]) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X
    
    void dfgeo(DOUBLE x[],DOUBLE gam[],LOGICAL lin,DOUBLE dl[],void *pk,
               void *pal,INTEGER nlen,INTEGER nanz,DOUBLE g[],INTEGER nx);

    static DOUBLE  dl[14];
    
    static INTEGER kf[][2] = {  {0,  0}, /* not used : indexes 0,0 */
    
                                {0,  1},
                                {0,  2},
                                {0,  3},
                                {0,  4},
                                {0,  5},
                                {0,  6},
                                {0,  7},
                                {0,  8},
                                {0,  9},
                                {0, 10},
                                {0, 11} };
                               
    static DOUBLE gamf[] = {0,1.e5};

    static DOUBLE alf[][2] = {  {0,  0            }, /* not used : indexes 0,0 */
    
                                {0, -0.001331720e0},
                                {0, -0.002270927e0},
                                {0, -0.00248546e0 },
                                {0, -4.67e0       },
                                {0, -4.671973e0   },
                                {0, -0.00814e0    },
                                {0, -0.008092e0   },
                                {0,  -.005e0      },
                                {0,  -.000909e0   },
                                {0, -0.00088e0    },
                                {0, -0.00119e0    } };

   
    
    dfgeo(x,gamf,FALSE,dl,kf,alf,11,1,gradf,12);
    
    return;
}

/* **************************************************************************** */
/*              compute the inequality constaints                               */
/* **************************************************************************** */
void econ(INTEGER type ,INTEGER liste[], DOUBLE x[],DOUBLE con[], 
              LOGICAL err[]) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X

    static INTEGER i; 
    static DOUBLE value ;   
    void fgeo(DOUBLE x[],DOUBLE con,DOUBLE gam[],LOGICAL lin,DOUBLE dl[],void *pk,
              void *pal,INTEGER nlen,INTEGER nanz,INTEGER nx,DOUBLE *fx);
    
    static DOUBLE gam2[] = { 0., /* not used : index 0 */
                            -1.e-9,-1.e-9,-1.e-3,-1.e-3,
                            -1.0898645e-1,-1.6108052e-5,-1.0e-23,-1.9304541e-8,
                            -1.e-4 };
                            
    static DOUBLE gam3[] = { 0., /* not used : index 0 */
                            -1.0898645e-1,-1.6108052e-5,-1.e-23,-1.9304541e-8,
                            -1.1184059e-4 };
                            
    static DOUBLE al2[][10] = {
            {0.e0,      0.e0, 0.e0, 0.e0, 0.e0, 0.e0, 0.e0, 0.e0, 0.e0, 0.e0},
             
            {0.e0,      1.e0, 1.e0, 1.e0, 1.e0, 1.e0, 1.e0, 1.e0, 1.e0, 1.e0},
            {0.e0,      1.e0,-1.e0,-1.e0, 1.e0, 1.e0, 1.e0, 1.e0,-1.e0,-1.e0},
            {0.e0,      0.e0, 0.e0, 0.e0, 0.e0, 0.e0,-1.e0, 1.e0, 1.e0, 0.e0},
            {0.e0,      0.e0, 0.e0, 0.e0, 0.e0, 0.e0, 0.e0, 0.e0,-2.e0, 0.e0} };
    
    static INTEGER k2[][10] = {
            {0,      0, 0, 0, 0, 0, 0, 0, 0, 0},
            
            {0,      4, 5, 6, 7, 4, 2, 2, 2,10},
            {0,     12,12,12,12, 5, 5, 4, 4,12},
            {0,      0, 0, 0, 0, 0,12, 5, 4, 0},
            {0,      0, 0, 0, 0, 0, 0, 0,12, 0} };

    static DOUBLE al3[][6] = {
            {0.e0,      0.e0, 0.e0, 0.e0, 0.e0, 0.e0},
             
            {0.e0,      1.e0, 1.e0, 1.e0, 1.e0, 1.e0},
            {0.e0,      1.e0, 1.e0, 1.e0,-1.e0, 1.e0},
            {0.e0,      0.e0, 0.e0, 1.e0, 1.e0, 0.e0} };
     
    static INTEGER k3[][6] = {
            {0,      0, 0, 0, 0, 0},
            
            {0,      4, 2, 2, 2, 1},
            {0,      5, 5, 4, 4, 9},
            {0,      0, 0, 5, 5, 0} };
    
    
    static DOUBLE dl2[] = { 0., /* not used : index 0 */
            -1.e-6,-1.e-5,-1.e-6,0.e0,0.e0,0.e0,0.e0,0.e0,0.e0,0.e0,0.e0,0.e0 };
            
    static DOUBLE dl3[] = { 0., /* not used : index 0 */
            -1.e-6,-1.e-5,-1.e-6,-1.e-9,
            -1.e-9,-1.e-3, 0.e0 ,-1.e-3,
            -1.e-5, 0.e0 ,-1.e-4, 0.e0 };
             
   
    for ( i=1; i<=3; i++)
    {
      switch (i) 
      {
      case 1:
        con[1] = 1.e0-5.36373e-2*x[1]-2.1863746e-2*x[2]-9.7733533e-2*x[3]
                -6.6940803e-3*x[4]*x[5];
        con[1] = con[1]*1.e1;
        
        break;
        
      case 2:
    
        fgeo(x,1.e0,gam2,TRUE,dl2,k2,al2,4,9,12,&value);
        
        con[2] = value*1.e1;
        
        break;
        
      case 3:

        fgeo(x,1.e0,gam3,TRUE,dl3,k3,al3,3,5,12,&value);
        
        con[3] = value*1.e2;
        
        break;
     }
   } 
   return;
}

/* **************************************************************************** */
/*              compute the gradient of the inequality constraints              */
/* **************************************************************************** */
void econgrad(INTEGER liste[] ,INTEGER shift ,  DOUBLE x[],
               DOUBLE **grad) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X
    void dfgeo(DOUBLE x[],DOUBLE gam[],LOGICAL lin,DOUBLE dl[],void *pk,
               void *pal,INTEGER nlen,INTEGER nanz,DOUBLE g[],INTEGER nx);

    static INTEGER i,j;
    static DOUBLE  s,p;
    static DOUBLE gradgi[14];
    static DOUBLE gam2[] = { 0., /* not used : index 0 */
                            -1.e-9,-1.e-9,-1.e-3,-1.e-3,
                            -1.0898645e-1,-1.6108052e-5,-1.0e-23,-1.9304541e-8,
                            -1.e-4 };
                            
    static DOUBLE gam3[] = { 0., /* not used : index 0 */
                            -1.0898645e-1,-1.6108052e-5,-1.e-23,-1.9304541e-8,
                            -1.1184059e-4 };
                            
    static DOUBLE al2[][10] = {
            {0.e0,      0.e0, 0.e0, 0.e0, 0.e0, 0.e0, 0.e0, 0.e0, 0.e0, 0.e0},
             
            {0.e0,      1.e0, 1.e0, 1.e0, 1.e0, 1.e0, 1.e0, 1.e0, 1.e0, 1.e0},
            {0.e0,      1.e0,-1.e0,-1.e0, 1.e0, 1.e0, 1.e0, 1.e0,-1.e0,-1.e0},
            {0.e0,      0.e0, 0.e0, 0.e0, 0.e0, 0.e0,-1.e0, 1.e0, 1.e0, 0.e0},
            {0.e0,      0.e0, 0.e0, 0.e0, 0.e0, 0.e0, 0.e0, 0.e0,-2.e0, 0.e0} };
    
    static INTEGER k2[][10] = {
            {0,      0, 0, 0, 0, 0, 0, 0, 0, 0},
            
            {0,      4, 5, 6, 7, 4, 2, 2, 2,10},
            {0,     12,12,12,12, 5, 5, 4, 4,12},
            {0,      0, 0, 0, 0, 0,12, 5, 4, 0},
            {0,      0, 0, 0, 0, 0, 0, 0,12, 0} };

    static DOUBLE al3[][6] = {
            {0.e0,      0.e0, 0.e0, 0.e0, 0.e0, 0.e0},
             
            {0.e0,      1.e0, 1.e0, 1.e0, 1.e0, 1.e0},
            {0.e0,      1.e0, 1.e0, 1.e0,-1.e0, 1.e0},
            {0.e0,      0.e0, 0.e0, 1.e0, 1.e0, 0.e0} };
     
    static INTEGER k3[][6] = {
            {0,      0, 0, 0, 0, 0},
            
            {0,      4, 2, 2, 2, 1},
            {0,      5, 5, 4, 4, 9},
            {0,      0, 0, 5, 5, 0} };
    
    static DOUBLE dl2[] = { 0., /* not used : index 0 */
            -1.e-6,-1.e-5,-1.e-6,0.e0,0.e0,0.e0,0.e0,0.e0,0.e0,0.e0,0.e0,0.e0 };
            
    static DOUBLE dl3[] = { 0., /* not used : index 0 */
            -1.e-6,-1.e-5,-1.e-6,-1.e-9,
            -1.e-9,-1.e-3, 0.e0 ,-1.e-3,
            -1.e-5, 0.e0 ,-1.e-4, 0.e0 };
             
    /*   con[i] = 1.e0-5.36373e-2*x[1]-2.1863746e-2*x[2]-9.7733533e-2*x[3] */
    /*          -6.6940803e-3*x[4]*x[5]                                  */
    /*   return                                                          */
    
    for ( i=1; i<=3; i++)
    {
    
      switch (i) 
      {
      case 1:
        for (j = 1 ; j <= 12 ; j++) {
            gradgi[j] = 0.e0;
        }
        gradgi[1] = -5.36373e-2;
        gradgi[2] = -2.1863746e-2;
        gradgi[3] = -9.7733533e-2;
        gradgi[4] = -x[5]*6.6940803e-3;
        gradgi[5] = -x[4]*6.6940803e-3;
        for (j = 1 ; j <= 12 ; j++) {
            grad[j][1] = gradgi[j]*1.e1;
        }
        break;
        
      case 2:

        dfgeo(x,gam2,TRUE,dl2,k2,al2,4,9,gradgi,12);
        
        for (j = 1 ; j <= 12 ; j++) {
            grad[j][2] = gradgi[j]*1.e1;
        }
        break;
        
      case 3:

        dfgeo(x,gam3,TRUE,dl3,k3,al3,3,5,gradgi,12);
        
        for (j = 1 ; j <= 12 ; j++) {
             grad[j][3]= gradgi[j]*1.e2;
        }
        break;
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

