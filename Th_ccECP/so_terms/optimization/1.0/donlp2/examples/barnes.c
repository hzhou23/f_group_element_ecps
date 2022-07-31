/* **************************************************************************** */
/*                                 user functions                               */
/* **************************************************************************** */
#include "o8para.h"

main() {
    void donlp2(void);
    
    donlp2();
    
    exit(0);
}
/* hs85 */

/* **************************************************************************** */
/*                              donlp2 standard setup                           */
/* **************************************************************************** */
void user_init_size(void) {
    #define  X extern
    #include "o8comm.h"
    #include "o8fint.h"
    #include "o8cons.h"
    #undef   X
    n = 5 ;
    nlin = 1 ;
    nonlin = 20 ;
    iterma = 4000;
    nstep = 20;
}


/* **************************************************************************** 
*/
/*                              donlp2-intv standard setup                      
     */
/* **************************************************************************** 
*/
void user_init(void) {
    #define  X extern
    #include "o8comm.h"
    #include "o8fint.h"
    #include "o8cons.h"
    #undef   X
    
    static INTEGER i,j;
    
    strcpy(name,"hs85orig");
    
    x[1] = 9.e2;
    x[2] = 8.e1;
    x[3] = 1.15e2;
    x[4] = 2.67e2;
    x[5] = 2.7e1;
    
    del0 = 1.e0;
    tau0 = 1.e0;
    tau  = .1e0;
    low[1] =     704.4148e0;
    low[2] =      68.6e0;
    low[3] =       0.e0;
    low[4] =     193.e0;
    low[5] =      25.e0;
    
    up[1] =     906.3855e0;
    up[2] =     288.88e0;
    up[3] =     134.75e0;
    up[4] =     287.0966e0;
    up[5] =      84.1988e0;
    for ( i=6; i<=9; i++ )    
    {
      low[i] = 0 ; /* the linear constraint */
      up[i] = 1.0e20 ; /* and the first three nonlinear constraints */
    }
    



    low[10] =     213.1e0;
    low[11] =      17.505e0;
    low[12] =      11.275e0;
    low[13] =     214.228e0;
    low[14] =       7.458e0;
    low[15] =        .961e0;
    low[16] =       1.612e0;
    low[17] =        .146e0;
    low[18] =     107.99e0;
    low[19] =     922.693e0;
    low[20] =     926.832e0;
    low[21] =      18.766e0;
    low[22] =    1072.163e0;
    low[23] =    8961.448e0;
    low[24] =        .063e0;
    low[25] =   71084.33e0;
    low[26] = 2802713.e0;

    up[10] =    405.23e0;
    up[11] =   1053.6667e0;
    up[12] =     35.03e0;
    up[13] =    665.585e0;
    up[14] =    584.463e0;
    up[15] =    265.916e0;
    up[16] =      7.046e0;
    up[17] =       .222e0;
    up[18] =    273.366e0;
    up[19] =   1286.105e0;
    up[20] =   1444.046e0;
    up[21] =    537.141e0;
    up[22] =   3247.039e0;
    up[23] =  26844.086e0;
    up[24] = .386e07;
    up[25] = 1.4e5;
    up[26] = 1.2146108e7;
    for ( i=1; i<=n; i++)
    {
      gres[i][1] = 0.0 ;
    }
    gres[2][1] = 1.5;
    gres[3][1] = -1.0 ;

    silent = FALSE;
    analyt = TRUE;
    epsdif = 0.e0;
 
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
    
    void cy(DOUBLE x[],DOUBLE c[],DOUBLE y[]);

    static DOUBLE c[18],y[18];
    
  
    
    cy(x,c,y);
    
    *fx = -5.843e-7*y[17]+1.17e-4*y[14]+2.358e-5*y[13]+1.502e-6*y[16]+
          3.21e-2*y[12]+4.324e-3*y[5]+1.e-4*c[15]/c[16]+37.48e0*y[2]
          /c[12] +.1365e0;
    
    return;
}

/* **************************************************************************** */
/*                          gradient of objective function                      */
/* **************************************************************************** */
void egradf(DOUBLE x[],DOUBLE gradf[]) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X
    
    void gcy(DOUBLE x[],DOUBLE c[],DOUBLE y[],DOUBLE gc[][18],DOUBLE gy[][18]);

    static INTEGER j;
    static DOUBLE  c[18],y[18],gc[6][18],gy[6][18];
    
      
    gcy(x,c,y,gc,gy);
    
    for (j = 1 ; j <= 5 ; j++) {
        gradf[j] = -5.843e-7*gy[j][17]+1.17e-4*gy[j][14]+2.358e-5*gy[j][13]
                   +1.502e-6*gy[j][16]+3.21e-2*gy[j][12]+4.3240e-3*gy[j][5]
                   +1.e-4  /c[16]*gc[j][15]- 1.e-4 *c[15]/pow(c[16],2)*gc[j][16]
                   +37.48e0/c[12]*gy[j][ 2]-37.48e0*y[ 2]/pow(c[12],2)*gc[j][12];
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

    
    void cy(DOUBLE x[],DOUBLE c[],DOUBLE y[]);
    
    static INTEGER k;
    static DOUBLE  c[18],y[18];
    cy(x,c,y);
    con[1] =  y[4]-.28e0/.72e0*y[5];
    con[2] =  21.e0-3.496e3*y[2]/c[12];
    con[3] = 6.2212e4/c[17]-y[1]-110.6e0;
    for ( k = 1; k <=17; k++)
    {
      con[k+3] = y[k] ;
    }
    return;
}

/* **************************************************************************** */
/*              compute the gradients  of the nonlinear constraints             */
/* **************************************************************************** */
void econgrad(INTEGER liste[] ,INTEGER shift ,  DOUBLE x[],
               DOUBLE **grad) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X

    
    void gcy(DOUBLE x[],DOUBLE c[],DOUBLE y[],DOUBLE gc[][18],DOUBLE gy[][18]);

    static INTEGER i,k,j;
    static DOUBLE  c[18],y[18],gc[6][18],gy[6][18];
    
    gcy(x,c,y,gc,gy);
    for (j = 1 ; j <= 5 ; j++) 
    {
      grad[j][1+shift] = gy[j][4]-.28e0/.72e0*gy[j][5];
    }
    for (j = 1 ; j <= 5 ; j++) 
    {
      grad[j][2+shift] = -3.496e3*(gy[j][2]-y[2]/c[12]*gc[j][12])/c[12];
    }
    for (j = 1 ; j <= 5 ; j++)
    {
      grad[j][3+shift] = -gy[j][1]-6.2212e4/pow(c[17],2)*gc[j][17];
    }
    for ( i=4; i<=nonlin; i++ )
      for (j = 1 ; j <= 5 ; j++) {
        grad[j][i+shift]  =  gy[j][i-3];
    }
    return;

}
void cy(DOUBLE x[],DOUBLE c[],DOUBLE y[]) {
    y[ 1] = x[2]+x[3]+41.6e0;
    c[ 1] = .024e0*x[4]-4.62e0;
    y[ 2] = 12.5e0/c[1]+12.e0;
    c[ 2] = (3.535e-4*x[1]+.5311e0+8.705e-2*y[2])*x[1];
    c[ 3] = (5.2e-2+2.377e-3*y[2])*x[1]+78.e0;
    y[ 3] = c[2]/c[3];
    y[ 4] = 19.e0*y[3];
    c[ 4] = (4.782e-2+.1956e0*(x[1]-y[3])/x[2])*(x[1]-y[3])
             +.6376e0*y[4]+1.594e0*y[3];
    c[ 5] = 1.e2*x[2];
    c[ 6] = x[1]-y[3]-y[4];
    c[ 7] = .95e0-c[4]/c[5];
    y[ 5] = c[6]*c[7];
    y[ 6] = x[1]-y[5]-y[4]-y[3];
    c[ 8] = (y[5]+y[4])*.995e0;
    y[ 7] = c[8]/y[1];
    y[ 8] = c[8]/3798.e0;
    c[ 9] = y[7]-.0663e0*y[7]/y[8]-.3153e0;
    y[ 9] = 96.82e0/c[9]+.321e0*y[1];
    y[10] = 1.29e0*y[5]+1.258e0*y[4]+2.29e0*y[3]+1.71e0*y[6];
    y[11] = 1.71e0*x[1]-.452e0*y[4]+.58e0*y[3];
    c[10] = 12.3e0/752.3e0;
    c[11] = 1.74125e0*y[2]*x[1];
    c[12] =  .995e0*y[10]+1998.e0;
    y[12] = c[10]*x[1]+c[11]/c[12];
    y[13] = c[12]-1.75e0*y[2];
    y[14] = 3623.e0+64.4e0*x[2]+58.4e0*x[3]+146312.e0/(y[9]+x[5]);
    c[13] = .995e0*y[10]+60.8e0*x[2]+48.e0*x[4]-.1121e0*y[14]-5095.e0;
    y[15] = y[13]/c[13];
    y[16] = 1.48e5-3.31e5*y[15]+4.e1*y[13]-6.1e1*y[15]*y[13];
    c[14] = 2324e0*y[10]-2.874e7*y[2];
    y[17] = 1.413e7-1328.e0*y[10]-531.e0*y[11]+c[14]/c[12];
    c[15] = y[13]*(1.e0/y[15]-1.e0/.52e0);
    c[16] = 1.104e0-.72e0*y[15];
    c[17] = y[9]+x[5];
    
    return;
}
void gcy(DOUBLE x[],DOUBLE c[],DOUBLE y[],DOUBLE gc[][18],DOUBLE gy[][18]) {
    void cy(DOUBLE x[],DOUBLE c[],DOUBLE y[]);

    static INTEGER j;

    cy(x,c,y);

    for (j = 1 ; j <= 5 ; j++) {
        gy[j][ 1] = 0.e0;
        gc[j][ 1] = 0.e0;
        gy[j][ 2] = 0.e0;
        gc[j][ 5] = 0.e0;
        gc[j][10] = 0.e0;
    }
    gy[2][ 1] = 1.e0;
    gy[3][ 1] = 1.e0;
    gc[4][ 1] = 0.024e0;
    gy[4][ 2] = -.3e0/pow(c[1],2);
    gc[2][ 5] = 1.e2;
    for (j = 1 ; j <= 5 ; j++) {
        gc[j][ 2] = .08705e0*x[1]*gy[j][2];
        gc[j][ 3] = 2.377e-3*x[1]*gy[j][2];
    }
    gc[1][ 2] = gc[1][2]+8.705e-2*y[2]+.5311e0+7.07e-4*x[1];
    gc[1][ 3] = gc[1][3]+5.2e-2+2.377e-3*y[2];
    for (j = 1 ; j <= 5 ; j++) {
        gy[j][ 3] = gc[j][2]/c[3]-c[2]/pow(c[3],2)*gc[j][3];
        gy[j][ 4] = 19.e0*gy[j][3];
        gc[j][ 4] = -(4.782e-2+.3912e0*(x[1]-y[3])/x[2])*gy[j][3]+
                    .6376e0*gy[j][4]+1.594e0*gy[j][3];
        gc[j][ 6] = -gy[j][3]-gy[j][4];
    }
    gc[1][ 6] = gc[1][6]+1.e0;
    gc[1][ 4] = gc[1][4]+4.782e-2+.3912e0*(x[1]-y[3])/x[2];
    gc[2][ 4] = gc[2][4]-.1956e0*pow((x[1]-y[3])/x[2],2);
    for (j = 1 ; j <= 5 ; j++) {
        gc[j][ 7] = -gc[j][4]/c[5]+c[4]/pow(c[5],2)*gc[j][5];
        gy[j][ 5] =  c[7]*gc[j][6]+c[6]*gc[j][7];
        gy[j][ 6] = -(gy[j][5]+gy[j][4]+gy[j][3]);
        gc[j][ 8] = .995e0*(gy[j][5]+gy[j][4]);
        gy[j][ 7] = gc[j][8]/y[1]-c[8]/pow(y[1],2)*gy[j][1];
        gy[j][ 8] = gc[j][8]/3798.e0;
        gc[j][ 9] = gy[j][7]*(1.e0-6.63e-2/y[8])+6.63e-2*y[7]/pow(y[8],2)*gy[j][8];
        gy[j][ 9] = .321e0*gy[j][1]-96.82e0/pow(c[9],2)*gc[j][9];
        gy[j][11] = -.452e0*gy[j][4]+.58e0*gy[j][3];
        gc[j][11] = 1.74125e0*x[1]*gy[j][2];
    }
    gy[1][ 6] = gy[1][6]+1.e0;
    gy[1][11] = gy[1][11]+1.71e0;
    gc[1][11] = gc[1][11]+1.74125e0*y[2];
    for (j = 1 ; j <= 5 ; j++) {
        gy[j][10] = 1.29e0*gy[j][5]+1.258e0*gy[j][4]+2.29e0*gy[j][3]+1.71e0
                    *gy[j][6];
        gc[j][12] = .995e0*gy[j][10];
        gy[j][12] = gc[j][11]/c[12]-c[11]/pow(c[12],2)*gc[j][12];
        gy[j][13] = gc[j][12]-1.75e0*gy[j][2];
        gc[j][17] = gy[j][9];
        gy[j][14] = -1.46312e5/pow(y[9]+x[5],2)*gy[j][9];
    }
    gy[1][12] = gy[1][12]+c[10];
    gy[2][14] = gy[2][14]+64.4e0;
    gy[3][14] = gy[3][14]+58.4e0;
    gy[5][14] = gy[5][14]-1.46312e5/pow(y[9]+x[5],2);
    for (j = 1 ; j <= 5 ; j++) {
        gc[j][13] = .995e0*gy[j][10]-.1121e0*gy[j][14];
    }
    gc[2][13] = gc[2][13]+60.8e0;
    gc[4][13] = gc[4][13]+48.0e0;
    gc[5][17] = gc[5][17]+ 1.0e0;
    for (j = 1 ; j <= 5 ; j++) {
        gy[j][15] = gy[j][13]/c[13]-y[13]/pow(c[13],2)*gc[j][13];
        gy[j][16] = -3.31e5*gy[j][15]+4.e1*gy[j][13]-6.1e1*(gy[j][15]
                    *y[13]+y[15]*gy[j][13]);
        gc[j][14] = 2.324e3*gy[j][10]-2.874e7*gy[j][2];
        gy[j][17] = -1.328e3*gy[j][10]-5.31e2*gy[j][11]+gc[j][14]/c[12]
                    -c[14]/pow(c[12],2)*gc[j][12];
        gc[j][15] = gy[j][13]*(1.e0/y[15]-1.e0/.52e0)-y[13]/pow(y[15],2)*gy[j][15];
        gc[j][16] = -.72e0*gy[j][15];
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

