/* **************************************************************************** */
/*                                 user functions                               */
/* **************************************************************************** */
#include "o8para.h"

main() {
    void donlp2(void);
    
    donlp2();
    
    exit(0);
}

#define XDIM    21
#define BDM     81

static DOUBLE  c11 = 2.e0, c12 =  8.e0, c13 =  250.e0;
static DOUBLE  c21 = 3.e0, c22 = 18.e0, c23 =  650.e0;
static DOUBLE  c31 = 4.e0, c32 = 50.e0, c33 = 1000.e0;

static DOUBLE  vi[BDM+1][XDIM+1],vi1[BDM+1][XDIM+1],vi2[BDM+1][XDIM+1],
               v11[BDM+1],v12[BDM+1],v13[BDM+1],
               v21[BDM+1],v22[BDM+1],v23[BDM+1],
               v31[BDM+1],v32[BDM+1],v33[BDM+1];
    
static DOUBLE  bb[XDIM+1];

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
    
    n      = XDIM;
    nlin   =  0;
    nonlin =  BDM*18;
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
    

    DOUBLE th11 (DOUBLE t);
    DOUBLE th12 (DOUBLE t);
    DOUBLE th13 (DOUBLE t);
    DOUBLE th21 (DOUBLE t);
    DOUBLE th22 (DOUBLE t);
    DOUBLE th23 (DOUBLE t);
    DOUBLE th31 (DOUBLE t);
    DOUBLE th32 (DOUBLE t);
    DOUBLE th33 (DOUBLE t);
    DOUBLE phil (INTEGER i, DOUBLE t);
    DOUBLE phil1(INTEGER i, DOUBLE t);
    DOUBLE phil2(INTEGER i, DOUBLE t);

    static INTEGER i,j,m;
    static DOUBLE  xst0[XDIM+1],h,tp;

    /*              other data declaration for cases a  b and c                 */
    /*                                                                          */
    /* a    for (i = 1 ; i <= XDIM ; i++) xst0[i] = 1.491400623321533e0;        */
    /* b    for (i = 1 ; i <= XDIM ; i++) xst0[i] = 4.377146244049071e0;        */
    /* c    for (i = 1 ; i <= XDIM ; i++) xst0[i] = 1.920426464080810e0;        */
    /* a    static DOUBLE  c11 = 2.e0, c12 =  8.e0, c13 =  250.e0;              */
    /* a    static DOUBLE  c21 = 3.e0, c22 = 18.e0, c23 =  650.e0;              */
    /* a    static DOUBLE  c31 = 4.e0, c32 = 50.e0, c33 = 1000.e0;              */
    /* b    static DOUBLE  c11 = 1.e0, c12 =  3.e0, c13 =  100.e0;              */
    /* b    static DOUBLE  c21 = 1.e0, c22 =  3.e0, c23 =  100.e0;              */
    /* b    static DOUBLE  c31 = 1.e0, c32 =  3.e0, c33 =  100.e0;              */
    /* c    static DOUBLE  c11 = 2.e0, c12 =  8.e0, c13 =   25.e0;              */
    /* c    static DOUBLE  c21 = 3.e0, c22 = 18.e0, c23 =   65.e0;              */
    /* c    static DOUBLE  c31 = 4.e0, c32 = 50.e0, c33 =  100.e0;              */
    /* a    strcpy(name,"robota");                                              */
    /* b    strcpy(name,"robotb");                                              */

    for (i = 1 ; i <= XDIM ; i++) {
        xst0[i] = 1.491400623321533e0;
    }
    strcpy(name,"robota");
    m = BDM ;
    h      = 1.e0/(n-1);
    silent = FALSE;
    analyt = TRUE;
    epsdif = 0.e0;
    del0   = 1.e0;
    tau0   = 1.e4;
    for (j = 1 ; j <= m ; j++) {
        tp     = (DOUBLE)(j-1)/(DOUBLE)(m-1);
        v11[j] = th11(tp);
        v12[j] = th12(tp);
        v13[j] = th13(tp);
        v21[j] = th21(tp);
        v22[j] = th22(tp);
        v23[j] = th23(tp);
        v31[j] = th31(tp);
        v32[j] = th32(tp);
        v33[j] = th33(tp);
        for (i = 1 ; i <= n ; i++) {
            vi [j][i] = phil(i,tp);
            vi1[j][i] = phil1(i,tp);
            vi2[j][i] = phil2(i,tp);
        }
    }
    for (i = 1 ; i <= n ; i++) {
        x[i]  = xst0[i];
        bb[i] = h;
    }
    bb[1]   = .5e0*h;
    bb[n]   = bb[1];
    bb[2]   = 23.e0*h/24.e0;
    bb[n-1] = bb[2];
    for ( i=1; i<=n; i++)
    {
       low[i] = -1.0e20; up[i] = 1.0e20;
    }
    for ( i=n+1; i<=n+nlin+nonlin; i++)
    {
      low[i]=0.0e0; up[i]=1.0e20;
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
    
    /* change termination criterion */
    
    epsx = 1.e-7;
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

    static INTEGER i;
    

    *fx = 0.e0;
    for (i = 1 ; i <= n ; i++) {
        *fx = *fx+bb[i]*x[i];
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

    static INTEGER i;
    

    for (i = 1 ; i <= n ; i++) {
        gradf[i] = bb[i];
    }
    return;
}

/* **************************************************************************** */
/*              compute the nonlinear constraints                               */
/* **************************************************************************** */
void econ(INTEGER type ,INTEGER liste[], DOUBLE x[],DOUBLE con[], 
              LOGICAL err[]) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X

    
    static INTEGER i,ip,k,j;
    static DOUBLE  sum,sum1,sum2;

    for ( i=1; i<=nonlin; i++)
    {
    
      ip   = (i-1)/18+1;
      k    = i-18*(ip-1);
      sum  = 0.e0;
      sum1 = 0.e0;
      sum2 = 0.e0;
      for (j = 1 ; j <= n ; j++) 
      {
        sum  = sum +vi [ip][j]*x[j];
        sum1 = sum1+vi1[ip][j]*x[j];
        sum2 = sum2+vi2[ip][j]*x[j];
      }
      switch (k) 
      {
        case 1:
        con[i] = c11*sum-v11[ip];
        break;
        case 2:
        con[i] = c11*sum+v11[ip];
        break;
        case 3:
        con[i] = c12*pow(sum,3)-(v12[ip]*sum-v11[ip]*sum1);
        break;
        case 4:
        con[i] = c12*pow(sum,3)+(v12[ip]*sum-v11[ip]*sum1);
        break;
        case 5:
        con[i] = c13*pow(sum,5)-(v13[ip]*pow(sum,2)-3.e0*v12[ip]*sum*sum1
               +3.e0*v11[ip]*pow(sum1,2)+v11[ip]*sum*sum2);
        break;
        case 6:
        con[i] = c13*pow(sum,5)+(v13[ip]*pow(sum,2)-3.e0*v12[ip]*sum*sum1
               +3.e0*v11[ip]*pow(sum1,2)+v11[ip]*sum*sum2);
        break;
        case 7:
        con[i] = c21*sum-v21[ip];
        break;
        case 8:
        con[i] = c21*sum+v21[ip];
        break;
        case 9:
        con[i] = c22*pow(sum,3)-(v22[ip]*sum-v21[ip]*sum1);
        break;
        case 10:
        con[i] = c22*pow(sum,3)+(v22[ip]*sum-v21[ip]*sum1);
        break;
        case 11:
        con[i] = c23*pow(sum,5)-(v23[ip]*pow(sum,2)-3.e0*v22[ip]*sum*sum1
               +3.e0*v21[ip]*pow(sum1,2)+v21[ip]*sum*sum2);
        break;
        case 12:
        con[i] = c23*pow(sum,5)+(v23[ip]*pow(sum,2)-3.e0*v22[ip]*sum*sum1
               +3.e0*v21[ip]*pow(sum1,2)+v21[ip]*sum*sum2);
        break;
        case 13:
        con[i] = c31*sum-v31[ip];
        break;
        case 14:
        con[i] = c31*sum+v31[ip];
        break;
        case 15:
        con[i] = c32*pow(sum,3)-(v32[ip]*sum-v31[ip]*sum1);
        break;
        case 16:
        con[i] = c32*pow(sum,3)+(v32[ip]*sum-v31[ip]*sum1);
        break;
        case 17:
        con[i] = c33*pow(sum,5)-(v33[ip]*pow(sum,2)-3.e0*v32[ip]*sum*sum1
               +3.e0*v31[ip]*pow(sum1,2)+v31[ip]*sum*sum2);
        break;
        case 18:
        con[i] = c33*pow(sum,5)+(v33[ip]*pow(sum,2)-3.e0*v32[ip]*sum*sum1
               +3.e0*v31[ip]*pow(sum1,2)+v31[ip]*sum*sum2);
        break;
      }
    }
    return;
}

/* **************************************************************************** */
/*              compute the gradients of the nonlinear constraints              */
/* **************************************************************************** */
void econgrad(INTEGER liste[] ,INTEGER shift ,  DOUBLE x[],
               DOUBLE **grad) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X

    static INTEGER i,ip,k,j;
    static DOUBLE  sum,sum1,sum2;
    
  for ( i=1; i<=nonlin; i++)
  {
    
    ip   = (i-1)/18+1;
    k    = i-18*(ip-1);
    sum  = 0.e0;
    sum1 = 0.e0;
    sum2 = 0.e0;
    for (j = 1 ; j <= n ; j++) 
    {
        sum  = sum +vi [ip][j]*x[j];
        sum1 = sum1+vi1[ip][j]*x[j];
        sum2 = sum2+vi2[ip][j]*x[j];
    }
    switch (k) 
    {
    case 1:
    case 2:
        for (j = 1 ; j <= n ; j++) {
            grad[j][i] = c11*vi[ip][j];
        }
        break;
    case 3:
        for (j = 1 ; j <= n ; j++) {
            grad[j][i] = 3.e0*c12*pow(sum,2)*vi[ip][j]-(v12[ip]*vi[ip][j]
                      -v11[ip]*vi1[ip][j]);
        }
        break;
    case 4:
        for (j = 1 ; j <= n ; j++) {
            grad[j][i] = 3.e0*c12*pow(sum,2)*vi[ip][j]+(v12[ip]*vi[ip][j]
                      -v11[ip]*vi1[ip][j]);
        }
        break;
    case 5:
        for (j = 1 ; j <= n ; j++) {
            grad[j][i] = 5.e0*c13*pow(sum,4)*vi[ip][j]-(2.e0*v13[ip]*sum*
                      vi[ip][j]-3.e0*v12[ip]*(sum1*vi[ip][j]+sum*vi1[ip][j])
                      +6.e0*v11[ip]*sum1*vi1[ip][j]+v11[ip]*
                      (sum2*vi[ip][j]+sum*vi2[ip][j]));
        }
        break;
    case 6:
        for (j = 1 ; j <= n ; j++) {
            grad[j][i] = 5.e0*c13*pow(sum,4)*vi[ip][j]+(2.e0*v13[ip]*sum*
                      vi[ip][j]-3.e0*v12[ip]*(sum1*vi[ip][j]+sum*vi1[ip][j])
                      +6.e0*v11[ip]*sum1*vi1[ip][j]+v11[ip]*
                      (sum2*vi[ip][j]+sum*vi2[ip][j]));
        }
        break;
    case 7:
    case 8:
        for (j = 1 ; j <= n ; j++) {
            grad[j][i] = c21*vi[ip][j];
        }
        break;
    case 9:
        for (j = 1 ; j <= n ; j++) {
            grad[j][i] = 3.e0*c22*pow(sum,2)*vi[ip][j]-(v22[ip]*vi[ip][j]
                      -v21[ip]*vi1[ip][j]);
        }
        break;
    case 10:
        for (j = 1 ; j <= n ; j++) {
            grad[j][i] = 3.e0*c22*pow(sum,2)*vi[ip][j]+(v22[ip]*vi[ip][j]
                      -v21[ip]*vi1[ip][j]);
        }
        break;
    case 11:
        for (j = 1 ; j <= n ; j++) {
            grad[j][i] = 5.e0*c23*pow(sum,4)*vi[ip][j]-(2.e0*v23[ip]*sum*
                      vi[ip][j]-3.e0*v22[ip]*(sum1*vi[ip][j]+sum*vi1[ip][j])
                      +6.e0*v21[ip]*sum1*vi1[ip][j]+v21[ip]*
                      (sum2*vi[ip][j]+sum*vi2[ip][j]));
        }
        break;
    case 12:
        for (j = 1 ; j <= n ; j++) {
            grad[j][i] = 5.e0*c23*pow(sum,4)*vi[ip][j]+(2.e0*v23[ip]*sum*
                      vi[ip][j]-3.e0*v22[ip]*(sum1*vi[ip][j]+sum*vi1[ip][j])
                      +6.e0*v21[ip]*sum1*vi1[ip][j]+v21[ip]*
                      (sum2*vi[ip][j]+sum*vi2[ip][j]));
        }
        break;
    case 13:
    case 14:
        for (j = 1 ; j <= n ; j++) {
            grad[j][i] = c31*vi[ip][j];
        }
        break;
    case 15:
        for (j = 1 ; j <= n ; j++) {
            grad[j][i] = 3.e0*c32*pow(sum,2)*vi[ip][j]-(v32[ip]*vi[ip][j]
                      -v31[ip]*vi1[ip][j]);
        }
        break;
    case 16:
        for (j = 1 ; j <= n ; j++) {
            grad[j][i] = 3.e0*c32*pow(sum,2)*vi[ip][j]+(v32[ip]*vi[ip][j]
                      -v31[ip]*vi1[ip][j]);
        }
        break;
    case 17:
        for (j = 1 ; j <= n ; j++) {
            grad[j][i] = 5.e0*c33*pow(sum,4)*vi[ip][j]-(2.e0*v33[ip]*sum*
                      vi[ip][j]-3.e0*v32[ip]*(sum1*vi[ip][j]+sum*vi1[ip][j])
                      +6.e0*v31[ip]*sum1*vi1[ip][j]+v31[ip]*
                      (sum2*vi[ip][j]+sum*vi2[ip][j]));
        }
        break;
    case 18:
        for (j = 1 ; j <= n ; j++) {
            grad[j][i] = 5.e0*c33*pow(sum,4)*vi[ip][j]+(2.e0*v33[ip]*sum*
                      vi[ip][j]-3.e0*v32[ip]*(sum1*vi[ip][j]+sum*vi1[ip][j])
                      +6.e0*v31[ip]*sum1*vi1[ip][j]+v31[ip]*
                      (sum2*vi[ip][j]+sum*vi2[ip][j]));
        }
        break;
       
    }
  }
  return;
}
DOUBLE f(DOUBLE t) {
    return pow(t,3)*((6.e0*t-15.e0)*t+10.e0);
}
DOUBLE f1(DOUBLE t) {
    return 30.e0*t*t*((t-2.e0)*t+1.e0);
}
DOUBLE f2(DOUBLE t) {
    return 60.e0*t*((2.e0*t-3.e0)*t+1.e0);
}
DOUBLE f3(DOUBLE t) {
    return (360.e0*t-360.e0)*t+60.e0;
}
DOUBLE th11(DOUBLE t) {
    DOUBLE f1(DOUBLE t);
    
    return 1.5e0*f1(t);
}
DOUBLE th12(DOUBLE t) {
    DOUBLE f2(DOUBLE t);
    
    return 1.5e0*f2(t);
}
DOUBLE th13(DOUBLE t) {
    DOUBLE f3(DOUBLE t);
    
    return 1.5e0*f3(t);
}
DOUBLE th21(DOUBLE t) {
    DOUBLE f(DOUBLE t);
    DOUBLE f1(DOUBLE t);
    
    return -.5e0*(cos(4.7e0*f(t))*4.7e0*f1(t));
}
DOUBLE th22(DOUBLE t) {
    DOUBLE f(DOUBLE t);
    DOUBLE f1(DOUBLE t);
    DOUBLE f2(DOUBLE t);

    return -.5e0*(-sin(4.7e0*f(t))*pow(4.7e0*f1(t),2)+cos(4.7e0*f(t))*
    4.7e0*f2(t));
}
DOUBLE th23(DOUBLE t) {
    DOUBLE f(DOUBLE t);
    DOUBLE f1(DOUBLE t);
    DOUBLE f2(DOUBLE t);
    DOUBLE f3(DOUBLE t);

    return -.5e0*(-cos(4.7e0*f(t))*pow(4.7e0*f1(t),3)-sin(4.7e0*f(t))*
    3.e0*pow(4.7e0,2)*f1(t)*f2(t)+cos(4.7e0*f(t))*f3(t)*4.7e0);
}
DOUBLE th31(DOUBLE t) {
    DOUBLE f1(DOUBLE t);

    return -1.3e0*f1(t);
}
DOUBLE th32(DOUBLE t) {
    DOUBLE f2(DOUBLE t);

    return -1.3e0*f2(t);
}
DOUBLE th33(DOUBLE t) {
    DOUBLE f3(DOUBLE t);

    return -1.3e0*f3(t);
}
DOUBLE phil(INTEGER i, DOUBLE t) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X
    
    static DOUBLE  h;
    static INTEGER k;
    
    h = 1.e0/(DOUBLE)(n-1);
    k = t/h+1.e-6+1;
    if ( i <= k-2 || i >= k+3 ) {
        return 0.e0;
    } else {
        switch (k-i+3) {
        case 1: 
            return pow(t-(DOUBLE)(k-1)*h,3)/6.e0/pow(h,3);
        case 2:
            return 1.e0/6.e0+(t-(DOUBLE)(k-1)*h)*.5e0/h
                    +pow(t-(DOUBLE)(k-1)*h,2)*.5e0/pow(h,2)
                    -pow(t-(DOUBLE)(k-1)*h,3)*.5e0/pow(h,3);
        case 3:
            return 1.e0/6.e0+((DOUBLE)(k)*h-t)*.5e0/h
                    +pow((DOUBLE)(k)*h-t,2)*.5e0/pow(h,2)
                    -pow((DOUBLE)(k)*h-t,3)*.5e0/pow(h,3);
        case 4:
            return pow((DOUBLE)(k)*h-t,3)/6.e0/pow(h,3);
        }
    }
    return 0.;
}
DOUBLE phil1(INTEGER i, DOUBLE t) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X
    
    static INTEGER k;
    static DOUBLE  h;
    
    h = 1.e0/(DOUBLE)(n-1);
    k = t/h+1.e-6+1;
    if ( i <= k-2 || i >= k+3 ) {
        return 0.e0;
    } else {
        switch (k-i+3) {
        case 1:
            return pow(t-(DOUBLE)(k-1)*h,2)/2.e0/pow(h,3);
        case 2:
            return .5e0/h+(t-(DOUBLE)(k-1)*h)/pow(h,2)
                    -pow(t-(DOUBLE)(k-1)*h,2)*1.5e0/pow(h,3);
        case 3:
            return -.5e0/h-((DOUBLE)(k)*h-t)/pow(h,2)
                    +pow((DOUBLE)(k)*h-t,2)*1.5e0/pow(h,3);
        case 4:
            return -pow((DOUBLE)(k)*h-t,2)/2.e0/pow(h,3);
        }
    }
    return 0.;
}
DOUBLE phil2(INTEGER i, DOUBLE t) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X
    
    static INTEGER k;
    static DOUBLE  h;
    
    h = 1.e0/(DOUBLE)(n-1);
    k = t/h+1.e-6+1;
    if ( i <= k-2 || i >= k+3 ) {
        return 0.e0;
    } else {
        switch (k-i+3) {
        case 1:
            return (t-(DOUBLE)(k-1)*h)/pow(h,3);
        case 2:
            return 1.e0/pow(h,2)-(t-(DOUBLE)(k-1)*h)*3.e0/pow(h,3);
        case 3:
            return 1.e0/pow(h,2)-((DOUBLE)(k)*h-t)*3.e0/pow(h,3);
        case 4:
            return ((DOUBLE)(k)*h-t)/pow(h,3);
        }
    }
    return 0.;
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

