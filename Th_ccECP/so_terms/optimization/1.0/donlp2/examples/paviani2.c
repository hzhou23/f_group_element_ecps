/* **************************************************************************** */
/*                                 user functions                               */
/* **************************************************************************** */
#include "o8para.h"
main() {
    void donlp2(void);
    
    donlp2();
    
    exit(0);
}

/* this is example Himmelblau 20 (Paviani n = 24) */

/* **************************************************************************** */
/*                              donlp2 standard setup                           */
/* **************************************************************************** */
void user_init_size(void) {
    #define  X extern
    #include "o8comm.h"
    #include "o8fint.h"
    #include "o8cons.h"
    #undef   X

    n    = 24;
    nlin = 0;
    nonlin = 22 ;
    iterma = 4000;
    nstep = 20;
}
void user_init(void) {
    #define  X extern
    #include "o8comm.h"
    #include "o8fint.h"

    static INTEGER i,j;

    strcpy(name,"paviani2");
    
    for (i = 1 ; i <= 24 ; i++) 
    {
        x[i] = 0.04e0; low[i]=0.0; up[i] = 1.0e20;
    }

    del0 = 0.00005e0;
    tau0 = 0.1e0;
    tau  = .1e0;
    
    for (j = 1 ; j <= 14 ; j++) 
    {
       low[j+n] = up[j+n] = 0.0;  /* 14 equality constraints */
    }
    
    for ( j=1; j<=8; j++)
    {
       low[j+n+14] = 0.0 ;  up[j+n+14] = 1.0e20;
    }

    silent = FALSE;
    analyt = TRUE;
    epsdif = 0.e0;
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
    static DOUBLE  a[] = {0., /* not used : index 0 */
                0.0693e0,0.0577e0,0.05e0,0.2e0 ,0.26e0  ,0.55e0  ,0.06e0,0.1e0,
                0.12e0  ,0.18e0  ,0.1e0 ,0.09e0,0.0693e0,0.0577e0,0.05e0,0.2e0,
                0.26e0  ,0.55e0  ,0.06e0,0.1e0 ,0.12e0  ,0.18e0  ,0.1e0 ,0.09e0};

    icf = icf+1;
    *fx = 0.e0;
    for (i = 1 ; i <= 24 ; i++) {
        *fx = *fx+a[i]*x[i];
    }
    *fx = *fx*100.e0;
    
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
    static DOUBLE  a[] = {0., /* not used : index 0 */
                0.0693e0,0.0577e0,0.05e0,0.2e0 ,0.26e0  ,0.55e0  ,0.06e0,0.1e0,
                0.12e0  ,0.18e0  ,0.1e0 ,0.09e0,0.0693e0,0.0577e0,0.05e0,0.2e0,
                0.26e0  ,0.55e0  ,0.06e0,0.1e0 ,0.12e0  ,0.18e0  ,0.1e0 ,0.09e0};

    icgf = icgf+1;
    for (i = 1 ; i <= 24 ; i++) {
        gradf[i] = a[i]*100.e0;
    }
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

    static INTEGER i,k,jj;
    static DOUBLE  s1,s2,f,value;
    static INTEGER ii,k1,k2,i1,i2,j;
    static DOUBLE  sum;

    static DOUBLE  e[] = {0., /* not used : index 0 */
                          0.1e0,0.3e0,0.4e0,0.3e0,0.6e0,0.3e0};

    static DOUBLE  b[] = {0., /* not used : index 0 */
                44.094e0,58.12e0  ,58.12e0 ,137.4e0 ,120.9e0  ,170.9e0,62.501e0,
                84.94e0 ,133.425e0,82.507e0, 46.07e0, 60.097e0};
                    
    static DOUBLE  c[] = {0., /* not used : index 0 */
                123.7e0,31.7e0,45.7e0 ,14.7e0 ,84.7e0,27.7e0,49.7e0,7.1e0,
                  2.1e0,17.7e0, 0.85e0, 0.64e0};
                    
    static DOUBLE  d[] = {0., /* not used : index 0 */
                31.244e0,36.12e0,34.784e0,92.7e0,82.7e0,91.6e0,56.708e0,
                82.7e0  ,80.8e0 ,64.517e0,49.4e0,49.1e0};
         
    /* we compute all constraints, irrespective of type and liste */
    f = 0.7302e0*530.e0*14.7e0/40.e0;
    for ( i=1; i<=14; i++)
    {
       if ( i > 12 ) goto L100;
    
       s2 = 0.e0;
       s1 = 0.e0;
       for (j = 13 ; j <= 24 ; j++) 
       {
        jj = j-12;
        s1 = s1+x[j]/b[jj];
        s2 = s2+x[jj]/b[jj];
       }
       value  = x[i+12]/(b[i]*s1)-c[i]*x[i]/(40.e0*b[i]*s2);
       goto L1000;
   
    
    L100:

      if ( i == 14 ) goto L200;
      sum = 0.e0;
      for (j = 1 ; j <= 24 ; j++) 
      {
        sum = sum+x[j];
      }
      value  = sum-1.e0;
      goto L1000;
    
    
    L200:

      s1 = 0.e0;
      s2 = 0.e0;
      for (j = 1 ; j <= 12 ; j++) {
        s1 = s1+x[j]/d[j];
        s2 = s2+x[j+12]/b[j];
      }
      value  = s1+f*s2-1.671e0;
    
  L1000: con[i] = value;
  }
  for ( k = 15; k<=22; k++ )
  {
    ii=k-14;
    switch (ii) 
    {
    case 1:
    case 2:
    case 3:
        k1 = 0;
        k2 = 12;
        
        L105:
        
        sum = 0.e0;
        for (j = 1 ; j <= 24 ; j++) {
            sum = sum+x[j];
        }
        i1   = ii+k1;
        i2   = ii+k2;
        con[k] = -(x[i1] + x[i2])/sum+e[ii];
        
        break;
        
        case 4:
        case 5:
        case 6:
        k1 = 3;
        k2 = 15;
        
        goto L105;
        
        case 7:
        con[k] = 0.e0;
        for (j = 1 ; j <= 12 ; j++) {
            con[k] = con[k]+x[j]*100.e0;
        }
        break;
        
        case 8:
        con[k] = 0.e0;
        for (j = 13 ; j <= 24 ; j++)
        {
            con[k] = con[k]+x[j]*100.e0;
        }
        break;
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



    static INTEGER i,j,k;
    static DOUBLE  s1,s2,f,xk1,xk2,xnen;

    static DOUBLE  b[] = {0., /* not used : index 0 */
                44.094e0,58.12e0  ,58.12e0 ,137.4e0 ,120.9e0  ,170.9e0,62.501e0,
                84.94e0 ,133.425e0,82.507e0, 46.07e0, 60.097e0};
                    
    static DOUBLE  c[] = {0., /* not used : index 0 */
                123.7e0,31.7e0,45.7e0 ,14.7e0 ,84.7e0,27.7e0,49.7e0,7.1e0,
                  2.1e0,17.7e0, 0.85e0, 0.64e0};
                    
    static DOUBLE  d[] = {0., /* not used : index 0 */
                31.244e0,36.12e0,34.784e0,92.7e0,82.7e0,91.6e0,56.708e0,
                82.7e0  ,80.8e0 ,64.517e0,49.4e0,49.1e0};
    static INTEGER ii,k1,k2,i1,i2;
    static DOUBLE  sum;

    static DOUBLE  e[] = {0., /* not used : index 0 */
                          0.1e0,0.3e0,0.4e0,0.3e0,0.6e0,0.3e0};
         
    static DOUBLE vec[25];
    
    f = 0.7302e0*530.e0*14.7e0/40.e0;
    
    for ( i=1; i<=14; i++)
    {
       if ( i  > 12 ) goto L200;
    
       s2 = 0.e0;
       s1 = 0.e0;
       for (j = 1 ; j <= 12 ; j++) 
       {
        s1 = s1+x[j+12]/b[j];
        s2 = s2+x[j]/b[j];
       }
       xk1 = 1.e0/b[i];
       xk2 = -c[i]/(40.e0*b[i]);
       for (j = 1 ; j <= 12 ; j++) 
       {
        vec[j] = 0.e0;
        if ( i == j ) vec[j] = s2;
        vec[j] = xk2*(vec[j]-x[i]/b[j])/pow(s2,2);
       }
       for (j = 13 ; j <= 24 ; j++) 
       {
        vec[j] = 0.e0;
        if ( i == j-12 ) vec[j] = s1;
        vec[j] = xk1*(vec[j]-x[i+12]/b[j-12])/pow(s1,2);
       }
       goto L1000;
    
    L200:

       if ( i == 14 ) goto L300;
    
      for (j = 1 ; j <= 24 ; j++) 
      {
        vec[j]  = 1.e0;
      }
      goto L1000;
    
    L300:

      for (j = 1 ; j <= 12 ; j++) 
      {
        vec[j] = 1.e0/d[j];
      }
      for (j = 13 ; j <= 24 ; j++) 
      {
        vec[j] = f/b[j-12];
      }
    L1000: 
      for ( j=1; j<=24; j++)
      {
        grad[j][i+shift] = vec[j];
      }
    } /* end i */
    for ( k = 15; k<=22; k++)
    {

      for (j = 1 ; j <= 24 ; j++) 
      {
        grad[j][k+shift] = 0.e0;
      }

      ii= k-14;
    
      switch (ii) 
      {
        case 1:
        case 2:
        case 3:
        k1 = 0;
        k2 = 12;
    
        L105:
    
        xnen = 0.e0;
        for (j = 1 ; j <= 24 ; j++) 
        {
            xnen = xnen+x[j];
        }
        i1 = ii+k1;
        i2 = ii+k2;
        for (j = 1 ; j <= 24 ; j++) 
        {
            if ( i1 == j || i2 == j ) grad[j][k] = -1.e0;
            grad[j][k+shift] = (grad[j][k+shift]*xnen+(x[i1]+x[i2]))/pow(xnen,2);
        }
        break;
        
        case 4:
        case 5:
        case 6:
        k1 = 3;
        k2 = 15;
        
        goto L105;
        
        case 7:
        for (j = 1 ; j <= 12 ; j++) 
        {
            grad[j][k+shift] = 100.e0;
        }
        break;
        
        case 8:
        for (j = 13 ; j <= 24 ; j++) {
            grad[j][k+shift] = 100.e0;
        }
        break;
      }
    } /* end k */
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

