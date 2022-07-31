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
    
    n      = 10;
    nlin   =  5;
    nonlin =  6;
    iterma = 4000;
    nstep = 20;
}


/* **************************************************************************** */
/*                              donlp2-intv standard setup                           */
/* **************************************************************************** */
void user_init(void) {
    #define  X extern
    #include "o8comm.h"
    #include "o8cons.h"
    #undef   X
    
    static INTEGER  i,j;
    static DOUBLE   xst0[11] = {0.,/* not used : index 0 */
                                1745.e0  ,12.e3  ,11.e1,3048.e0 ,1974.e0,
                                  89.2e0 ,92.8e0 , 8.e0,   3.6e0, 145.e0 };
    static DOUBLE ugloc[11] = {0.,/* not used : index 0 */
                              1.e-5, 1.e-5,1.e-5,1.e-5,  1.e-5,
                             85.e0, 90.e0 ,3.e0 ,1.2e0,145.e0 };
    static DOUBLE ogloc[11] = {0.,/* not used : index 0 */
                              2.e3 ,16.e3, 1.2e2,5.e3,  2.e3,
                              93.e0,95.e0,12.e0, 4.e0,162.e0 };
    static DOUBLE   acons = .99e0,bcons = .9e0,ccons = 1.01010101010101e0,
                    dcons = 1.11111111111111e0;
                                  
    /* name is ident of the example/user and can be set at users will       */
    /* the first static character must be alphabetic. 40 characters maximum */

    strcpy(name,"alkylscal");
     
    /* x is initial guess and also holds the current solution */
    /* problem dimension n = dim(x), nlin=number of linear constraints
       nonlin = number of nonlinear constraints  */
    for ( i=1; i<=n; i++) 
    { xsc[i] = pow(2.0,i);
    }    
    analyt = TRUE;
    epsdif = 1.e-16;   /* gradients exact to machine precision */
    /* if you want numerical differentiation being done by donlp2 then:*/
    /* epsfcn   = 1.e-16; *//* function values exact to machine precision */
    /* taubnd   = 5.e-6; */
    /* bounds may be violated at most by taubnd in finite differencing */
    /*  bloc    = TRUE; */
    /* if one wants to evaluate all functions  in an independent process */
    /* difftype = 3; *//* the most accurate and most expensive choice */
    
    nreset = n;
    
    
    del0 = 0.2e0;
    tau0 = 1.e0;
    tau  = 0.1e0;
    for (i = 1 ; i <= n ; i++) {
        x[i] = xst0[i];
    }
    
    del0=del0/1024.0;
    /*  set lower and upper bounds */
    big = 1.e20;
    for ( i = 1 ; i <= 10 ; i++ ) { low[i]=ugloc[i];}
    low[11] = -35.82;
    low[13] = 35.82;
    low[12] = 133.0 ;
    low[14] = -133.0;
    low[15]=0.0;
    for ( i = 16 ; i<=21; i++ ) {low[i]=0.0;}
    for ( i = 1 ; i<= 10 ; i++ ) {up[i]=ogloc[i];}
    for ( i = 11 ; i<= 14; i++ ) {up[i]=big;}  
    /* 4 linear inequality constraints >=0*/
    up[15]=0.0;   /* linear equality constraint */
    for ( i=16; i<= 19; i++ ) {up[i]=big;}
    /* 4 nonlinear inequality constraints >=0 */
    up[20] = up[21] = 0.0 ;
    /* two nonlinear equalities =0*/

    /* store coefficients of linear constraints directly in gres */


    for ( i = 1 ; i<= 5 ; i++ )
    { 
      for  ( j = 1 ; j <= 10 ; j++ )
        {
          gres[j][i] = 0.0 ;
        }
    }
    gres[9][1] = - bcons;
    gres[10][1]= -0.222;
    gres[7][2] = 3.0;
    gres[10][2]= -acons;
    gres[9][3] = 1.0/bcons;
    gres[10][3]= 0.222;
    gres[7][4] = -3.0;
    gres[10][4]=1.0/acons;
    gres[1][5] = -1.0;
    gres[5][5] = -1.0;
    gres[4][5] = 1.22;

    
    return;
}

/* **************************************************************************** */
/*                                 special setup                                */
/* **************************************************************************** */
void setup(void) {
    #define  X extern
    #include "o8comm.h"
    #undef   X
    te0=TRUE;
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


    *fx = 5.04e0*x[1]+.035e0*x[2]+10.e0*x[3]+3.36e0*x[5]-.063e0*x[4]*x[7];
    
    return;
}

/* **************************************************************************** */
/*                          gradient of objective function                      */
/* **************************************************************************** */
void egradf(DOUBLE x[],DOUBLE gradf[]) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X

    static INTEGER  j;
    static DOUBLE   a[11] = {0.,/* not used : index 0 */
                             5.04e0,0.035e0,10.e0,0.e0,3.36e0,
                             0.e0  ,0.e0   , 0.e0,0.e0,0.e0};


    for (j = 1 ; j <= 10 ; j++) {
        gradf[j] = a[j];
    }
    gradf[4] = -0.063e0*x[7];
    gradf[7] = -0.063e0*x[4];
    
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
    static INTEGER liste_loc[7];
    static DOUBLE   a = .99e0,b = .9e0,c = 2.01010101010101e-2,
                    d = 2.11111111111111e-1;
    static DOUBLE   t;
/* the six nonlinear constraints are evaluated and stored in con[1],..,con[6] */
/* if type != 1 only a selection is evaluated the indices being taken from    */
/* liste. since we have no evaluation errors here err is never touched        */


    if ( type == 1 ) 
    {
       liste_loc[0] = 6 ;
       for ( i = 1 ; i<=6 ; i++ ) { liste_loc[i] = i ; }
    }
    else
    {
       liste_loc[0] = liste[0] ;
       for ( i = 1 ; i<=liste[0] ; i++ ) { liste_loc[i] = liste[i];}
    }
    for ( j = 1 ; j <= liste_loc[0] ; j++ )
    {
      i = liste_loc[j] ;
      
      switch (i) {
      case 1:
        con[1] =1.12e0*x[1]+.13167e0*x[1]*x[8]-.00667e0*x[1]*pow(x[8],2)-a*x[4];
        continue; 
      case 2:
        t = 1.12e0*x[1]+.13167e0*x[1]*x[8]-.00667e0*x[1]*pow(x[8],2)-a*x[4];
        con[2] =  -t+c*x[4];
        continue;
      case 3:
        con[3] = 57.425e0+1.098e0*x[8]-.038e0*pow(x[8],2)+.325e0*x[6]-a*x[7];
        continue; 
      case 4: 
        t= 57.425e0+1.098e0*x[8]-.038e0*pow(x[8],2)+.325e0*x[6]-a*x[7];
        con[4] = -t+c*x[7];
        continue;
      case 5:
        con[5]  = 9.8e4*x[3]/(x[4]*x[9]+1.e3*x[3])-x[6];
        continue;
      case 6:
        con[6]  = (x[2]+x[5])/x[1]-x[8];
        continue;
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

    static INTEGER  i,j,k;
    static DOUBLE   t,t1;
    
    static INTEGER liste_loc[7];
    static DOUBLE   a = .99e0,b = .9e0,c = 2.01010101010101e-2,
                    d = 2.11111111111111e-1;

    liste_loc[0] = liste[0] ;
    for ( i = 1 ; i<=liste_loc[0] ; i++ ) { liste_loc[i] = liste[i];}
    for ( j = 1 ; j <= liste_loc[0] ; j++ )
    {
      i = liste_loc[j] ;
      for (k = 1 ; k <= 10 ; k++) 
      {
           grad[k][i+shift] = 0.e0;
      }
      switch (i) {
      case 1: 
/* con[1] =1.12e0*x[1]+.13167e0*x[1]*x[8]-.00667e0*x[1]*pow(x[8],2)-a*x[4];*/
        grad[1][i+shift] = 1.12e0+.13167e0*x[8]-.00667e0*pow(x[8],2);
        grad[4][i+shift] = -a;
        grad[8][i+shift] = .13167e0*x[1]-.01334e0*x[1]*x[8];
        continue;
      case 2:
/*
        t = 1.12e0*x[1]+.13167e0*x[1]*x[8]-.00667e0*x[1]*pow(x[8],2)-a*x[4];
        con[2] =  -t+c*x[4];
*/
        grad[1][i+shift] = -(1.12e0+.13167e0*x[8]-.00667e0*pow(x[8],2));
        grad[8][i+shift] = -(.13167e0*x[1]-.01334e0*x[1]*x[8]);
        grad[4][i+shift] = 1.0/a;
        continue;
      case 3:
/* con[3] = 57.425e0+1.098e0*x[8]-.038e0*pow(x[8],2)+.325e0*x[6]-a*x[7]; */
        grad[6][i+shift] = .325e0;
        grad[7][i+shift] = -a;
        grad[8][i+shift] = 1.098e0-.076e0*x[8];
        continue;
      case 4:
/*
        t= 57.425e0+1.098e0*x[8]-.038e0*pow(x[8],2)+.325e0*x[6]-a*x[7];
        con[4] = -t+c*x[7];
*/
        grad[6][i+shift] = -.325e0;
        grad[7][i+shift] = 1.0/a;
        grad[8][i+shift] = -(1.098e0-.076e0*x[8]);

        continue;

      case 5: 
        t         = 9.8e4/(x[4]*x[9]+1.e3*x[3]);
        t1        = t/(x[4]*x[9]+1.e3*x[3])*x[3];
        grad[3][i+shift] = t-1.e3*t1;
        grad[4][i+shift] = -x[9]*t1;
        grad[9][i+shift] = -x[4]*t1;
        grad[6][i+shift] = -1.e0;
        continue;
       case 6: 
        grad[1][i+shift] = -(x[2]+x[5])/pow(x[1],2);
        grad[2][i+shift] = 1.e0/x[1];
        grad[5][i+shift] = 1.e0/x[1];
        grad[8][i+shift] = -1.e0;
        continue;
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

