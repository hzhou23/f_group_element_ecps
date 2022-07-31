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
/*                              donlp2-intv size initialization                 */
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
    #include "o8fint.h"
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

    strcpy(name,"alkbloc3");
     
    /* x is initial guess and also holds the current solution */
    /* problem dimension n = dim(x), nlin=number of linear constraints
       nonlin = number of nonlinear constraints  */
    
    analyt = FALSE;
    epsdif = 1.e-8;   /* gradients exact to machine precision */
    /* if you want numerical differentiation being done by donlp2 then:*/
     epsfcn   = 1.e-16; /* function values exact to machine precision */


    /*  bloc    = TRUE; */
    /* if one wants to evaluate all functions  in an independent process */
    /* difftype = 3; *//* the most accurate and most expensive choice */
    difftype = 3 ;    
    bloc = TRUE ;
    nreset = n;
    
    
    del0 = 0.2e0;
    tau0 = 1.e0;
    tau  = 0.1e0;
    for (i = 1 ; i <= n ; i++) {
        x[i] = xst0[i];
    }
    

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
/*                compute the i-th equality constaint, value is hxi             */
/* **************************************************************************** */
void econ(INTEGER type ,INTEGER liste[], DOUBLE x[],DOUBLE con[], 
              LOGICAL err[]) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X
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
    INTEGER  j,k;
    DOUBLE   fa[11] = {0.,/* not used : index 0 */
                             5.04e0,0.035e0,10.e0,0.e0,3.36e0,
                             0.e0  ,0.e0   , 0.e0,0.e0,0.e0};
    DOUBLE t,t1 ;
    DOUBLE   acons = .99e0,ccons = 2.01010101010101e-2;
              

    if ( mode == 1 ) 
    {
/*  compute the objective function and the nonlinear constraints   */
    fu[0] = 5.04e0*xtr[1]+.035e0*xtr[2]+10.e0*xtr[3]+3.36e0*xtr[5]-.063e0*xtr[4]*xtr[7];
    fu[1] =1.12e0*xtr[1]+.13167e0*xtr[1]*xtr[8]-.00667e0*xtr[1]*pow(xtr[8],2)-acons*xtr[4];
    t = 1.12e0*xtr[1]+.13167e0*xtr[1]*xtr[8]-.00667e0*xtr[1]*pow(xtr[8],2)-acons*xtr[4];
    fu[2] =  -t+ccons*xtr[4];
    fu[3] = 57.425e0+1.098e0*xtr[8]-.038e0*pow(xtr[8],2)+.325e0*xtr[6]-acons*xtr[7];
    t= 57.425e0+1.098e0*xtr[8]-.038e0*pow(xtr[8],2)+.325e0*xtr[6]-acons*xtr[7];
    fu[4] = -t+ccons*xtr[7];
    fu[5]  = 9.8e4*xtr[3]/(xtr[4]*xtr[9]+1.e3*xtr[3])-xtr[6];
    fu[6]  = (xtr[2]+xtr[5])/xtr[1]-xtr[8];
    return;
    }
    else 
    { 
/*  compute the objective function , the nonlinear constraints and their 
    gradients */
    fu[0] = 5.04e0*xtr[1]+.035e0*xtr[2]+10.e0*xtr[3]+3.36e0*xtr[5]-.063e0*xtr[4]*xtr[7];
    fu[1] =1.12e0*xtr[1]+.13167e0*xtr[1]*xtr[8]-.00667e0*xtr[1]*pow(xtr[8],2)-acons*xtr[4];
    t = 1.12e0*xtr[1]+.13167e0*xtr[1]*xtr[8]-.00667e0*xtr[1]*pow(xtr[8],2)-acons*xtr[4];
    fu[2] =  -t+ccons*xtr[4];
    fu[3] = 57.425e0+1.098e0*xtr[8]-.038e0*pow(xtr[8],2)+.325e0*xtr[6]-acons*xtr[7];
    t= 57.425e0+1.098e0*xtr[8]-.038e0*pow(xtr[8],2)+.325e0*xtr[6]-acons*xtr[7];
    fu[4] = -t+ccons*xtr[7];
    fu[5]  = 9.8e4*xtr[3]/(xtr[4]*xtr[9]+1.e3*xtr[3])-xtr[6];
    fu[6]  = (xtr[2]+xtr[5])/xtr[1]-xtr[8];
    for (j = 1 ; j <= 10 ; j++) {
        fugrad[j][0] = fa[j]; 
        for ( k = 1; k<= 6; k++ ) 
        {
          fugrad[j][k] = 0.0;
        }
    }
    fugrad[4][0] = -0.063e0*xtr[7];
    fugrad[7][0] = -0.063e0*xtr[4];
    fugrad[1][1] = 1.12e0+.13167e0*xtr[8]-.00667e0*pow(xtr[8],2);
    fugrad[4][1] = -acons;
    fugrad[8][1] = .13167e0*xtr[1]-.01334e0*xtr[1]*xtr[8];
    fugrad[1][2] = -(1.12e0+.13167e0*xtr[8]-.00667e0*pow(xtr[8],2));
    fugrad[8][2] = -(.13167e0*xtr[1]-.01334e0*xtr[1]*xtr[8]);
    fugrad[4][2] = 1.0/acons;
    fugrad[6][3] = .325e0;
    fugrad[7][3] = -acons;
    fugrad[8][3] = 1.098e0-.076e0*xtr[8];
    fugrad[6][4] = -.325e0;
    fugrad[7][4] = 1.0/acons;
    fugrad[8][4] = -(1.098e0-.076e0*xtr[8]);
    t         = 9.8e4/(xtr[4]*xtr[9]+1.e3*xtr[3]);
    t1        = t/(xtr[4]*xtr[9]+1.e3*xtr[3])*xtr[3];
    fugrad[3][5] = t-1.e3*t1;
    fugrad[4][5] = -xtr[9]*t1;
    fugrad[9][5] = -xtr[4]*t1;
    fugrad[6][5] = -1.e0;
    fugrad[1][6] = -(xtr[2]+xtr[5])/pow(xtr[1],2);
    fugrad[2][6] = 1.e0/xtr[1];
    fugrad[5][6] = 1.e0/xtr[1];
    fugrad[8][6] = -1.e0;
    return;
    }

}

