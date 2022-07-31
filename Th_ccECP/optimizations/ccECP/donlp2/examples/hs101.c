/* **************************************************************************** 
*/
/*                                 user functions                               
*/
/* **************************************************************************** 
*/
#include "o8para.h"
main() {
    void donlp2(void);
    
    donlp2();
    
    exit(0);
}

   
/* **************************************************************************** */
/*                              donlp2 standard setup                           */
/* **************************************************************************** */
/* from Hock & Schittkowski */
/*    hs101  */
void user_init_size(void) {
    #define  X extern
    #include "o8comm.h"
    #include "o8fint.h"
    #include "o8cons.h"
    #undef   X


    /* problem dimension n = dim(x), nlin=number of linear constraints
       nonlin = number of nonlinear constraints  */
    
    n      = 7;
    nlin   =  0;
    nonlin =  6;
    iterma = 4000;
    nstep = 20;
}
    
void user_init(void) {
    #define  X extern
    #include "o8comm.h"
    #include "o8fint.h"
    #include "o8cons.h"
    #undef   X
    static DOUBLE ugloc[] = { 0., /* not used : index 0 */
            .1e0,.1e0,.1e0,.1e0,.1e0,.1e0,.01e0 };
    

    static INTEGER i;

    strcpy(name,"hs101");

    for (i = 1 ; i <= 7 ; i++) {
        x[i] = 6.e0; low[i] = ugloc[i]; up[i] = 10.0 ;      
    }
    for ( i = n+1; i<=n+nonlin ; i++) 
    {
        low[i] = 0.0 ;  up[i] = 1.0e20;
    }

    del0 = 0.05e0;
    tau0 = 0.05e0;
    tau  = 0.1e0;
    cold   = TRUE;
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
    
    void fgeo(DOUBLE x[],DOUBLE con,DOUBLE gam[],LOGICAL lin,DOUBLE dl[],void *pk,
              void *pal,INTEGER nlen,INTEGER nanz,INTEGER nx,DOUBLE *fx);

    static DOUBLE  dl[8];
     
    static INTEGER kf[][5] = {
            {0,      0, 0, 0, 0},
            
            {0,      1, 1, 1, 1},
            {0,      2, 2, 2, 2},
            {0,      4, 3, 4, 3},
            {0,      6, 4, 5, 5},
            {0,      7, 5, 6, 6},
            {0,      0, 7, 0, 7} };
                            
    static DOUBLE gamf[] = { 0., /* not used : index 0 */
                            10.e0,15.e0,20.e0,25.e0 };
    
    static DOUBLE alf[][5] = {
            {0.e0,      0.e0, 0.e0, 0.e0, 0.e0},
             
            {0.e0,       1.e0  , -1.e0,-2.e0, 2.e0 },
            {0.e0,      -1.e0  , -2.e0, 1.e0, 2.e0 },
            {0.e0,       2.e0  ,  1.e0,-1.e0,-1.e0 },
            {0.e0,      -3.e0  ,  1.e0,-2.e0,  .5e0},
            {0.e0,      -0.25e0, -1.e0, 1.e0,-2.e0 },
            {0.e0,       0.e0  , -.5e0, 0.e0, 1.e0 } };
                

    
    fgeo(x,0.e0,gamf,FALSE,dl,kf,alf,6,4,7,fx);
    
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

    static DOUBLE  dl[8];
     
    static INTEGER kf[][5] = {
            {0,      0, 0, 0, 0},
            
            {0,      1, 1, 1, 1},
            {0,      2, 2, 2, 2},
            {0,      4, 3, 4, 3},
            {0,      6, 4, 5, 5},
            {0,      7, 5, 6, 6},
            {0,      0, 7, 0, 7} };
                            
    static DOUBLE gamf[] = { 0., /* not used : index 0 */
                            10.e0,15.e0,20.e0,25.e0 };
    
    static DOUBLE alf[][5] = {
            {0.e0,      0.e0, 0.e0, 0.e0, 0.e0},
             
            {0.e0,       1.e0  , -1.e0,-2.e0, 2.e0 },
            {0.e0,      -1.e0  , -2.e0, 1.e0, 2.e0 },
            {0.e0,       2.e0  ,  1.e0,-1.e0,-1.e0 },
            {0.e0,      -3.e0  ,  1.e0,-2.e0,  .5e0},
            {0.e0,      -0.25e0, -1.e0, 1.e0,-2.e0 },
            {0.e0,       0.e0  , -.5e0, 0.e0, 1.e0 } };


    
    dfgeo(x,gamf,FALSE,dl,kf,alf,6,4,gradf,7);
    
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
    
    void fgeo(DOUBLE x[],DOUBLE con,DOUBLE gam[],LOGICAL lin,DOUBLE dl[],void *pk,
              void *pal,INTEGER nlen,INTEGER nanz,INTEGER nx,DOUBLE *fx);
    
    static DOUBLE  dl[8],gxi;
     
    static INTEGER kf[][5] = {
            {0,      0, 0, 0, 0},
            
            {0,      1, 1, 1, 1},
            {0,      2, 2, 2, 2},
            {0,      4, 3, 4, 3},
            {0,      6, 4, 5, 5},
            {0,      7, 5, 6, 6},
            {0,      0, 7, 0, 7} };
                            
    static DOUBLE gamf[] = { 0., /* not used : index 0 */
                            10.e0,15.e0,20.e0,25.e0 };
    
    static DOUBLE alf[][5] = {
            {0.e0,       0.e0  ,  0.e0, 0.e0, 0.e0},
             
            {0.e0,       1.e0  , -1.e0,-2.e0, 2.e0 },
            {0.e0,      -1.e0  , -2.e0, 1.e0, 2.e0 },
            {0.e0,       2.e0  ,  1.e0,-1.e0,-1.e0 },
            {0.e0,      -3.e0  ,  1.e0,-2.e0,  .5e0},
            {0.e0,      -0.25e0, -1.e0, 1.e0,-2.e0 },
            {0.e0,       0.e0  , -.5e0, 0.e0, 1.e0 } };
            
    static DOUBLE gam1[] = { 0., /* not used : index 0 */
                            -.5e-3,-.7e-3,-.2e-3,0.e0 };

    static DOUBLE gam2[] = { 0., /* not used : index 0 */
                            -1.3e-3,-.8e-3,-3.1e-3,0.e-3 };
                            
    static DOUBLE gam3[] = { 0., /* not used : index 0 */
                            -2.0e-3,-.1e-3,-1.0e-3,-.65e-3 };
                            
    static DOUBLE gam4[] = { 0., /* not used : index 0 */
                            -.20e-3,-.3e-3,-.40e-3,-.5e-3 };
                            
    static DOUBLE al1[][5] = {
            {0.e0,       0.e0, 0.e0 , 0.e0              ,0.e0},
             
            {0.e0,       .5e0, 3.e0 ,-1.e0              ,0.e0},
            {0.e0,      -1.e0, 1.e0 , 1.e0              ,0.e0},
            {0.e0,      -2.e0,-2.e0 ,- .5e0             ,0.e0},
            {0.e0,       1.e0, 1.e0 ,  .66666666666666e0,0.e0},
            {0.e0,       0.e0,  .5e0,  .25e0            ,0.e0},
            {0.e0,       0.e0, 0.e0 , 0.e0              ,0.e0} };
             
    static DOUBLE al2[][5] = {
            {0.e0,       0.e0 , 0.e0, 0.e0              ,0.e0},
             
            {0.e0,      - .5e0, 1.e0,-1.e0              ,0.e0},
            {0.e0,       1.e0 ,-1.e0,  .5e0             ,0.e0},
            {0.e0,      -1.e0 ,-1.e0,-2.e0              ,0.e0},
            {0.e0,      -1.e0 , 2.e0,-1.e0              ,0.e0},
            {0.e0,       1.e0 , 0.e0,  .33333333333333e0,0.e0},
            {0.e0,       0.e0 , 0.e0, 0.e0              ,0.e0} };
             
    static DOUBLE al3[][5] = {
            {0.e0,       0.e0              , 0.e0 , 0.e0 , 0.e0},
             
            {0.e0,       1.e0              , 1.e0 ,-1.e0 ,-2.e0},
            {0.e0,      -1.5e0             ,- .5e0, 1.e0 , 1.e0},
            {0.e0,       1.e0              , 1.e0 ,  .5e0, 1.e0},
            {0.e0,      -1.e0              ,-1.e0 , 1.e0 ,-1.e0},
            {0.e0,        .33333333333333e0,- .5e0, 0.e0 , 1.e0},
            {0.e0,       0.e0              , 0.e0 , 0.e0 , 0.e0} };
                            
    static DOUBLE al4[][5] = {
            {0.e0,       0.e0              , 0.e0              , 0.e0  , 0.e0 },
             
            {0.e0,      -2.e0              ,  .5e0             ,-3.e0  ,-2.e0 },
            {0.e0,       1.e0              , 2.e0              ,-2.e0  , 1.e0 },
            {0.e0,      -1.e0              , 1.e0              , 1.e0  ,  .5e0},
            {0.e0,        .5e0             ,  .33333333333333e0, 1.e0  , 0.e0 },
            {0.e0,        .33333333333333e0,  .25e0            ,  .75e0, 0.e0 },
            {0.e0,       0.e0              , -.66666666666666e0, 0.e0  , 0.e0 } };

    static INTEGER k1[][5] = {
            {0,      0, 0, 0, 0},
            
            {0,      1, 1, 2, 0},
            {0,      3, 2, 3, 0},
            {0,      6, 3, 4, 0},
            {0,      7, 6, 6, 0},
            {0,      0, 7, 7, 0},
            {0,      0, 0, 0, 0} };

    static INTEGER k2[][5] = {
            {0,      0, 0, 0, 0},
            
            {0,      1, 3, 1, 0},
            {0,      2, 4, 2, 0},
            {0,      3, 5, 4, 0},
            {0,      5, 6, 5, 0},
            {0,      6, 0, 6, 0},
            {0,      0, 0, 0, 0} };

    static INTEGER k3[][5] = {
            {0,      0, 0, 0, 0},
            
            {0,      1, 2, 1, 2},
            {0,      3, 3, 2, 3},
            {0,      5, 5, 3, 5},
            {0,      6, 6, 5, 6},
            {0,      7, 7, 0, 7},
            {0,      0, 0, 0, 0} };
    
    static INTEGER k4[][5] = {
            {0,      0, 0, 0, 0},
            
            {0,      1, 1, 1, 3},
            {0,      2, 2, 2, 4},
            {0,      4, 3, 3, 7},
            {0,      5, 4, 5, 0},
            {0,      7, 7, 7, 0},
            {0,      0, 5, 0, 0} };
                            
    static DOUBLE ug[] = { 0., /* not used : index 0 */
            .1e0,.1e0,.1e0,.1e0,.1e0,.1e0,.01e0 };
    
        fgeo(x,1.e-3,gam1,FALSE,dl,k1,al1,6,4,7,&gxi);
        con[1] = gxi;

        fgeo(x,1.e-3,gam2,FALSE,dl,k2,al2,6,4,7,&gxi);
        con[2] = gxi ;
        fgeo(x,1.e-3,gam3,FALSE,dl,k3,al3,6,4,7,&gxi);
        con[3] = gxi;
        fgeo(x,1.e-3,gam4,FALSE,dl,k4,al4,6,4,7,&gxi);
        con[4] = gxi ;
        fgeo(x,-1.e2,gamf,FALSE,dl,kf,alf,6,4,7,&gxi);
        con[5] = gxi ;
        fgeo(x,-3.e3,gamf,FALSE,dl,kf,alf,6,4,7,&gxi);
        con[6] = -gxi;

    
    return;
}

/* **************************************************************************** */
/*              compute the gradient of the nonlinear       constraint          */
/* **************************************************************************** */
void econgrad(INTEGER liste[] ,INTEGER shift ,  DOUBLE x[],
               DOUBLE **grad) {

    #define  X extern
    #include "o8fuco.h"
    #undef   X
    
    void dfgeo(DOUBLE x[],DOUBLE gam[],LOGICAL lin,DOUBLE dl[],void *pk,
               void *pal,INTEGER nlen,INTEGER nanz,DOUBLE g[],INTEGER nx);

    static DOUBLE  dl[8], gradgi[8];
    static INTEGER i,j;
     
    static INTEGER kf[][5] = {
            {0,      0, 0, 0, 0},
            
            {0,      1, 1, 1, 1},
            {0,      2, 2, 2, 2},
            {0,      4, 3, 4, 3},
            {0,      6, 4, 5, 5},
            {0,      7, 5, 6, 6},
            {0,      0, 7, 0, 7} };
                            
    static DOUBLE gamf[] = { 0., /* not used : index 0 */
                            10.e0,15.e0,20.e0,25.e0 };
    
    static DOUBLE alf[][5] = {
            {0.e0,       0.e0  ,  0.e0, 0.e0, 0.e0},
             
            {0.e0,       1.e0  , -1.e0,-2.e0, 2.e0 },
            {0.e0,      -1.e0  , -2.e0, 1.e0, 2.e0 },
            {0.e0,       2.e0  ,  1.e0,-1.e0,-1.e0 },
            {0.e0,      -3.e0  ,  1.e0,-2.e0,  .5e0},
            {0.e0,      -0.25e0, -1.e0, 1.e0,-2.e0 },
            {0.e0,       0.e0  , -.5e0, 0.e0, 1.e0 } };
            
    static DOUBLE gam1[] = { 0., /* not used : index 0 */
                            -.5e-3,-.7e-3,-.2e-3,0.e0 };

    static DOUBLE gam2[] = { 0., /* not used : index 0 */
                            -1.3e-3,-.8e-3,-3.1e-3,0.e-3 };
                            
    static DOUBLE gam3[] = { 0., /* not used : index 0 */
                            -2.0e-3,-.1e-3,-1.0e-3,-.65e-3 };
                            
    static DOUBLE gam4[] = { 0., /* not used : index 0 */
                            -.20e-3,-.3e-3,-.40e-3,-.5e-3 };
                            
    static DOUBLE al1[][5] = {
            {0.e0,       0.e0, 0.e0 , 0.e0              ,0.e0},
             
            {0.e0,       .5e0, 3.e0 ,-1.e0              ,0.e0},
            {0.e0,      -1.e0, 1.e0 , 1.e0              ,0.e0},
            {0.e0,      -2.e0,-2.e0 ,- .5e0             ,0.e0},
            {0.e0,       1.e0, 1.e0 ,  .66666666666666e0,0.e0},
            {0.e0,       0.e0,  .5e0,  .25e0            ,0.e0},
            {0.e0,       0.e0, 0.e0 , 0.e0              ,0.e0} };
             
    static DOUBLE al2[][5] = {
            {0.e0,       0.e0 , 0.e0, 0.e0              ,0.e0},
             
            {0.e0,      - .5e0, 1.e0,-1.e0              ,0.e0},
            {0.e0,       1.e0 ,-1.e0,  .5e0             ,0.e0},
            {0.e0,      -1.e0 ,-1.e0,-2.e0              ,0.e0},
            {0.e0,      -1.e0 , 2.e0,-1.e0              ,0.e0},
            {0.e0,       1.e0 , 0.e0,  .33333333333333e0,0.e0},
            {0.e0,       0.e0 , 0.e0, 0.e0              ,0.e0} };
             
    static DOUBLE al3[][5] = {
            {0.e0,       0.e0              , 0.e0 , 0.e0 , 0.e0},
             
            {0.e0,       1.e0              , 1.e0 ,-1.e0 ,-2.e0},
            {0.e0,      -1.5e0             ,- .5e0, 1.e0 , 1.e0},
            {0.e0,       1.e0              , 1.e0 ,  .5e0, 1.e0},
            {0.e0,      -1.e0              ,-1.e0 , 1.e0 ,-1.e0},
            {0.e0,        .33333333333333e0,- .5e0, 0.e0 , 1.e0},
            {0.e0,       0.e0              , 0.e0 , 0.e0 , 0.e0} };
                            
    static DOUBLE al4[][5] = {
            {0.e0,       0.e0              , 0.e0              , 0.e0  , 0.e0 },
             
            {0.e0,      -2.e0              ,  .5e0             ,-3.e0  ,-2.e0 },
            {0.e0,       1.e0              , 2.e0              ,-2.e0  , 1.e0 },
            {0.e0,      -1.e0              , 1.e0              , 1.e0  ,  .5e0},
            {0.e0,        .5e0             ,  .33333333333333e0, 1.e0  , 0.e0 },
            {0.e0,        .33333333333333e0,  .25e0            ,  .75e0, 0.e0 },
            {0.e0,       0.e0              , -.66666666666666e0, 0.e0  , 0.e0 } };

    static INTEGER k1[][5] = {
            {0,      0, 0, 0, 0},
            
            {0,      1, 1, 2, 0},
            {0,      3, 2, 3, 0},
            {0,      6, 3, 4, 0},
            {0,      7, 6, 6, 0},
            {0,      0, 7, 7, 0},
            {0,      0, 0, 0, 0} };

    static INTEGER k2[][5] = {
            {0,      0, 0, 0, 0},
            
            {0,      1, 3, 1, 0},
            {0,      2, 4, 2, 0},
            {0,      3, 5, 4, 0},
            {0,      5, 6, 5, 0},
            {0,      6, 0, 6, 0},
            {0,      0, 0, 0, 0} };

    static INTEGER k3[][5] = {
            {0,      0, 0, 0, 0},
            
            {0,      1, 2, 1, 2},
            {0,      3, 3, 2, 3},
            {0,      5, 5, 3, 5},
            {0,      6, 6, 5, 6},
            {0,      7, 7, 0, 7},
            {0,      0, 0, 0, 0} };
    
    static INTEGER k4[][5] = {
            {0,      0, 0, 0, 0},
            
            {0,      1, 1, 1, 3},
            {0,      2, 2, 2, 4},
            {0,      4, 3, 3, 7},
            {0,      5, 4, 5, 0},
            {0,      7, 7, 7, 0},
            {0,      0, 5, 0, 0} };

        /* shift not used since nlin=0 */
        dfgeo(x,gam1,FALSE,dl,k1,al1,6,4,gradgi,7);
        for ( i=1 ; i<=7; i++)
        {
          grad[i][1] = gradgi[i] ;
        }
        
        dfgeo(x,gam2,FALSE,dl,k2,al2,6,4,gradgi,7);
         for ( i=1 ; i<=7; i++)
        {
          grad[i][2] = gradgi[i] ;
        }

        dfgeo(x,gam3,FALSE,dl,k3,al3,6,4,gradgi,7);
        for ( i=1 ; i<=7; i++)
        {
          grad[i][3] = gradgi[i] ;
        }
        
        dfgeo(x,gam4,FALSE,dl,k4,al4,6,4,gradgi,7);
        for ( i=1 ; i<=7; i++)
        {
          grad[i][4] = gradgi[i] ;
        }
        dfgeo(x,gamf,FALSE,dl,kf,alf,6,4,gradgi,7);
        for ( i=1 ; i<=7; i++)
        {
          grad[i][5] = gradgi[i] ;
        }
        dfgeo(x,gamf,FALSE,dl,kf,alf,6,4,gradgi,7);
        for ( i=1 ; i<=7; i++)
        {
          grad[i][6] = -gradgi[i] ;
        }
        

}

/* **************************************************************************** */
/* evaluate a generalized polynomial given by con,dl,gam,al,k                   */
/* at x giving fx. if lin = FALSE, dl is not used                               */
/* here                                                                         */
/*                   { 0 if lin = FALSE                   }                     */
/* fx = f(x) = con + {                                    }+                    */
/*                   { sum(i = 1,n){dl[i]*x[i]} otherwise }                     */
/*                                                                              */
/*           + sum(i=1,nanz){gam[i]*(prod(j=1,nlen){pow(x[k[j][i],al[j][i])} }  */
/*                                                                              */
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
/* evaluate the gradient of a generalized polynomial function                   */
/* defined by gam,al,k,dl at the point x giving g                               */
/* for function definition see fgeo above                                       */
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

