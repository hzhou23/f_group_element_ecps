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
    
    n      = 16;
    nlin   =  0;
    nonlin =  19;
    iterma = 4000;
    nstep = 20;
}
void user_init(void) {
    #define  X extern
    #include "o8comm.h"
    #include "o8fint.h"
    #include "o8cons.h"
    #undef   X
    
    static INTEGER  i,j;
    static DOUBLE ugloc[] = {0., /* not used : index 0 */
                    0.1e0,0.1e0,0.1e0,0.1e0, .9e0,1.e-4, .1e0, .1e0,
                     .1e0, .1e0,1.e-2,1.e-8,1.e-2,5.e0 ,5.e0 ,1.e-8 };
                     
    static DOUBLE ogloc[] = {0., /* not used : index 0 */
                    .9e0,.9e0, .9e0, .9e0,1.e0,0.1e0, .9e0, .9e0,
                    .9e0,.9e0,1.e1 ,5.e0 ,5.e0,1.e1 ,1.e1 ,5.e0 };

    /* dembo 7 example */



    strcpy(name,"dembo7");
    
    x[ 1] = .8e0;
    x[ 2] = .83e0;
    x[ 3] = .85e0;
    x[ 4] = .87e0;
    x[ 5] = .9e0;
    x[ 6] = .1e0;
    x[ 7] = .12e0;
    x[ 8] = .19e0;
    x[ 9] = .25e0;
    x[10] = .29e0;
    x[11] = 512.e-2;
    x[12] =  13.1e-2;
    x[13] =  71.8e-2;
    x[14] = 640.e-2;
    x[15] = 650.e-2;
    x[16] =   5.7e-2;
         
    for ( i=1; i<=n; i++)
    {
       low[i] = ugloc[i]; up[i] = ogloc[i]; 
    }
    for ( i=n+1; i<= n+nlin+nonlin; i++)
    {
       low[i] = 0.0 ; up[i] = 1.0e20;
    }
    
    del0 = 0.005e0;
    tau0 = .009e0;
    tau  = .1e0;
    
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

    static INTEGER i;
    static DOUBLE  c[] = {0., /* not used : index 0 */
                    1.262626e0, 1.262626e0, 1.262626e0, 1.262626e0, 1.262626e0,
                   -1.231060e0,-1.231060e0,-1.231060e0,-1.231060e0,-1.231060e0};
    
    
    *fx = 0.e0;
    for (i = 1 ; i <= 5 ; i++) {
        *fx = *fx+c[i]*x[i+11]+c[i+5]*x[i]*x[i+11];
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

    static INTEGER j;
    static DOUBLE  c[] = {0., /* not used : index 0 */
                    1.262626e0, 1.262626e0, 1.262626e0, 1.262626e0, 1.262626e0,
                   -1.231060e0,-1.231060e0,-1.231060e0,-1.231060e0,-1.231060e0};

    
    for (j = 1 ; j <= 16 ; j++) {
        gradf[j] = 0.e0;
    }
    for (j = 1 ; j <= 5 ; j++) {
        gradf[j] = c[j+5]*x[j+11];
    }
    for (j = 12 ; j <= 16 ; j++) {
        gradf[j] = c[j-11]+c[j-6]*x[j-11];
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

    
    static INTEGER i,i1,ii,k;
    static DOUBLE  gx,f1,f2;
    static DOUBLE  x12,x13,x14,x15,x16;

    static DOUBLE  d[] = {0., /* not used : index 0 */        
                    1.e0,1.e0,1.e0,1.e0,1.e0,1.e0,1.e0,1.e0,
                    1.e0,1.e0,1.e0,1.e0,1.e0,1.e0,1.e0,1.e0 };
    

    static DOUBLE c[]  = {0., /* not used : index 0 */
         0.03475e0,0.975e0,-0.975e-2,0.03475e0,0.975e0,-0.975e-2,
         0.03475e0,0.975e0,-0.975e-2,0.03475e0,0.975e0,-0.975e-2,
         0.03475e0,0.975e0,-0.975e-2,
         1.e0  ,1.e0  , -1.e0  ,   1.e0  ,   0.2e-2,0.2e-2,-0.2e-2,-0.2e-2,1.e0,
         0.2e-2,0.2e-2,  1.e0  ,  -0.2e-2,  -0.2e-2,
         1.e0  ,1.e0  ,500.e0  ,-500.e0  ,  -1.e0  ,
         1.e0  ,1.e0  ,500.e0  ,  -1.e0  ,-500.e0  ,
         0.9e0 ,0.2e-2, -0.2e-2,   0.2e-2,  -0.2e-2,
         1.e0  ,1.e0  ,  1.e0  ,   1.e0  ,   1.e0  ,1.e0  ,1.e0};
    
    for ( i1=1; i1<=19; i1++)
    {
      switch (i1) 
      {
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
        ii = (i1-1)*3;
        gx = c[ii+1]*x[i1]/x[i1+5]+c[ii+2]*x[i1]+c[ii+3]*pow(x[i1],2)/x[i1+5];
        break;
      case 6:
        f1 = x[6]/x[7];
        f2 = x[12]/x[11]/x[7];
        gx = c[16]*f1 + c[17]*x[1]*f2 + c[18]*x[6]*f2;
        break;
      case 7:
        x12 = x[12]*1.e2;
        x13 = x[13]*1.e2;
        gx  = c[19]*x[7]/x[8]+c[20]*x[7]*x12/x[8] + c[21]*x[2]*x13/x[8]
            + c[22]*x13 + c[23]*x[1]*x12/x[8];
        break;
      case 8:
        x13 = x[13]*1.e2;
        x14 = x[14]*1.e2;
        gx  = c[24]*x[8]+c[25]*x[8]*x13+c[26]*x[3]*x14+
              c[27]*x[9]+c[28]*x[2]*x13+c[29]*x[9]*x14;
        break;
      case 9:
        x14 = x[14]*1.e2;
        x15 = x[15]*1.e2;
        gx  = c[30]*x[9]/x[3]+c[31]*x[4]*x15/x[3]/x14+c[32]*x[10]/x[3]
              /x14+c[33]*x[9]/x[3]/x14+c[34]*x[8]*x15/x[3]/x14;
        break;
      case 10:
        x15 = x[15]*1.e2;
        x16 = x[16]*1.e2;
        gx  = c[35]*x[5]/x[4]*x16/x15+c[36]*x[10]/x[4]+c[37]/x15
             +c[38]*x16/x15+c[39]*x[10]/x15/x[4];
        break;
      case 11:
        x16 = x[16]*1.e2;
        gx  = c[40]/x[4]+c[41]*x16+c[42]*x[5]/x[4]*x16;
        break;
      case 12:
        gx  = (c[43]*x[11]+c[44]*x[12])*1.e2;
        break;
      case 13:
        gx  = c[45]*x[12]/x[11];
        break;
      case 14:
      case 15:
      case 16:
      case 17:
      case 18:
      case 19:
        k = (INTEGER)fabs(i1-19);
        if(k == 1)  k = 10;
        if(k == 0)  k =  9;
        gx = c[i1+32]*x[k-1]/x[k];
        break;
      }
      con[i1] = 1.e0-gx;
   } 
   return;
}

/* **************************************************************************** */
/*              compute the gradients  of the  inequality constraints           */
/* **************************************************************************** */
void econgrad(INTEGER liste[] ,INTEGER shift ,  DOUBLE x[],
               DOUBLE **grad) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X

    static DOUBLE  x3,x4,x8,x12,x13,x14,x15,x16,x142,x152;
    static INTEGER i,k,i1,ii;
    static DOUBLE gradgi[17];
    static DOUBLE  d[] = {0., /* not used : index 0 */        
                    1.e0,1.e0,1.e0,1.e0,1.e0,1.e0,1.e0,1.e0,
                    1.e0,1.e0,1.e0,1.e0,1.e0,1.e0,1.e0,1.e0 };
    
    static DOUBLE c[] = {0., /* not used : index 0 */
         0.03475e0,0.975e0,-0.975e-2,0.03475e0,0.975e0,-0.975e-2,
         0.03475e0,0.975e0,-0.975e-2,0.03475e0,0.975e0,-0.975e-2,
         0.03475e0,0.975e0,-0.975e-2,
         1.e0  ,1.e0  , -1.e0  ,   1.e0  ,   0.2e-2,0.2e-2,-0.2e-2,-0.2e-2,1.e0,
         0.2e-2,0.2e-2,  1.e0  ,  -0.2e-2,  -0.2e-2,
         1.e0  ,1.e0  ,500.e0  ,-500.e0  ,  -1.e0  ,
         1.e0  ,1.e0  ,500.e0  ,  -1.e0  ,-500.e0  ,
         0.9e0 ,0.2e-2, -0.2e-2,   0.2e-2,  -0.2e-2,
         1.e0  ,1.e0  ,  1.e0  ,   1.e0  ,   1.e0  ,1.e0  ,1.e0};
         
    for ( i=1; i<=19; i++)
    {

      for (k = 1 ; k <= 16 ; k++) 
      {
        gradgi[k] = 0.e0;
      }
 
      i1  = i;
    
      switch (i1) 
      {
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
        ii           = (i1-1)*3;
        gradgi[i1]   = c[ii+1]/x[i1+5] + c[ii+2]+2.e0*c[ii+3]*x[i1]/x[i1+5];
        gradgi[i1+5] = (-c[ii+1]*x[i1]-c[ii+3]*pow(x[i1],2))/pow(x[i1+5],2);
        break;
      case 6:
        gradgi[1]  = c[17]*x[12]/x[7]/x[11];
        gradgi[6]  = c[16]/x[7]+c[18]*x[12]/x[7]/x[11];
        gradgi[7]  = -c[16]*x[6]/pow(x[7],2)-c[17]*x[1]/pow(x[7],2)/x[11]*x[12]-
                      c[18]*x[6]*x[12]/pow(x[7],2)/x[11];
        gradgi[11] = -c[17]*x[1]/x[7]/pow(x[11],2)*x[12]-c[18]*x[6]/x[7]
                     /pow(x[11],2)*x[12];
        gradgi[12] = c[17]*x[1]/x[7]/x[11]+c[18]*x[6]/x[7]/x[11];
        break;
      case 7:
        x12        = x[12]*1.e2;
        x13        = x[13]*1.e2;
        gradgi[1]  =  c[23]*x12/x[8];
        gradgi[2]  =  c[21]*x13/x[8];
        gradgi[7]  = c[19]/x[8] + c[20]*x12/x[8];
        x8         = pow(x[8],2);
        gradgi[8]  = -c[19]*x[7]/x8-c[20]*x[7]*x12/x8-c[21]*x[2]*x13/x8
                    - c[23]*x[1]*x12/x8;
        gradgi[12] = ( c[20]*x[7]/x[8] + c[23]*x[1]/x[8])*1.e2;
        gradgi[13] =  (c[21]*x[2]/x[8]+c[22])*1.e2;
        break;
      case 8:
        x13        = x[13]*1.e2;
        x14        = x[14]*1.e2;
        gradgi[2]  = c[28]*x13;
        gradgi[3]  = c[26]*x14;
        gradgi[8]  = c[24]+c[25]*x13;
        gradgi[9]  = c[27]+c[29]*x14;
        gradgi[13] = (c[25]*x[8]+c[28]*x[2])*1.e2;
        gradgi[14] = (c[26]*x[3]+c[29]*x[9])*1.e2;
        break;
      case 9:
        x14        = x[14]*1.e2;
        x15        = x[15]*1.e2;
        x3         = pow(x[3],2);
        gradgi[3]  = -c[30]*x[9]/x3-c[31]*x[4]*x15/x3/x14-c[32]*x[10]/x3
                     /x14-c[33]*x[9]/x3/x14-c[34]*x[8]*x15/x3/x14;
        gradgi[4]  = c[31]*x15/x[3]/x14;
        gradgi[8]  = c[34]*x15/x[3]/x14;
        gradgi[9]  = c[30]/x[3]+c[33]/x[3]/x14;
        gradgi[10] = c[32]/x[3]/x14;
        x142       = pow(x14,2);
        gradgi[14] = (-c[31]*x[4]*x15/x[3]/x142-c[32]*x[10]/x[3]
                     /x142-c[33]*x[9]/x[3]/x142-c[34]*x[8]*x15/x[3]/x142)*1.e2;
        gradgi[15] = (c[31]*x[4]/x[3]/x14+c[34]*x[8]/x[3]/x14)*1.e2;
        break;
      case 10:
        x15        = x[15]*1.e2;
        x4         = pow(x[4],2);
        x16        = x[16]*1.e2;
        gradgi[4]  = -c[35]*x[5]/x4*x16/x15-c[36]*x[10]/x4
                     -c[39]*x[10]/x15/x4;
        gradgi[5]  = c[35]/x[4]*x16/x15;
        gradgi[10] = c[36]/x[4]+c[39]/x15/x[4];
        x152       = pow(x15,2);
        gradgi[15] = (-c[35]*x[5]/x[4]*x16/x152-c[37]/x152
                     -c[38]*x16/x152-c[39]*x[10]/x152/x[4])*1.e2;
        gradgi[16] = (c[35]*x[5]/x[4]/x15+c[38]/x15)*1.e2;
        break;
      case 11:
        x4         = pow(x[4],2);
        x16        = x[16]*1.e2;
        gradgi[4]  = -c[40]/x4-c[42]*x[5]/x4*x16;
        gradgi[5]  =  c[42]/x[4]*x16;
        gradgi[16] = (c[41] + c[42]/x[4]*x[5])*1.e2;
        break;
      case 12:
        gradgi[11] = c[43]*1.e2;
        gradgi[12] = c[44]*1.e2;
        break;
      case 13:
        gradgi[11] = -c[45]*x[12]/pow(x[11],2);
        gradgi[12] =  c[45]/x[11];
        break;
      case 14:
      case 15:
      case 16:
      case 17:
      case 18:
      case 19:
        k = (INTEGER)fabs(i1-19);
        if ( k == 1 ) k = 10;
        if ( k == 0 ) k =  9;
        gradgi[k]   = -c[i1+32]*x[k-1]/pow(x[k],2);
        gradgi[k-1] =  c[i1+32]/x[k];
        break;
      }
      for (k = 1 ; k <= 16 ; k++) 
      {
        grad[k][i] = -gradgi[k];
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

