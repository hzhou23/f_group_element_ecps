/* **************************************************************************** */
/*                                 user functions                               */
/* **************************************************************************** */
#include "o8para.h"

main() {
    void donlp2(void);
    
    donlp2();
    
    exit(0);
}
/* Maratos's example, showing the well known effect of stepsize reduction */
/* Change donlp's parameter smalld in order to see it!                    */

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
    
    n      = 2;
    nlin   =  0;
    nonlin =  1;
    iterma = 4000;
    nstep = 20;
}
void user_init(void) {
    #define  X extern
    #include "o8comm.h"
    #include "o8fint.h"
    #include "o8cons.h"
    #undef   X

    static INTEGER j;

    strcpy(name,"maratos0");

    x[1] = 0.8e0;
    x[2] = 0.6e0;

    del0 = 1.00e-1;
    tau0 = 0.5e0;
    tau  = .1e0;
    analyt = TRUE;
    epsdif = 0.e0;
    nreset = 4;
    silent = FALSE;
    low[1] = low[2] = -1.0e20;
    up[1] = up[2] = 1.0e20;
    low[3] = up[3] = 1.0e0;


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

    icf = icf+1;
    
    *fx = -x[1] + 10.e0*(pow(x[1],2)+pow(x[2],2)-1.e0);
    
    return;
}

/* **************************************************************************** */
/*                          gradient of objective function                      */
/* **************************************************************************** */
void egradf(DOUBLE x[],DOUBLE gradf[]) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X

    icgf = icgf+1;
    
    gradf[1] = -1.e0+20.e0*x[1];
    gradf[2] = 20.e0*x[2];
    
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
    con[1] = pow(x[1],2)+pow(x[2],2);
    return;
}
/* **************************************************************************** */
/* **************************************************************************** */
void econgrad(INTEGER liste[] ,INTEGER shift ,  DOUBLE x[],
               DOUBLE **grad) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X
    grad[1][shift+1]=2.0*x[1];
    grad[2][shift+1]=2.0*x[2];
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

