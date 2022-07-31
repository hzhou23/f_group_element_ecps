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
 *        nonlin = number of nonlinear constraints  */
    
    n      =  6;
    nlin   =  0;
    nonlin =  0;
    iterma = 50;
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
    
    static INTEGER  i,j;

    /* loc_expt_1, loc_expt_3, loc_expt_2,loc_coeff_2, s_expt_1, s_coeff_1 */
    static DOUBLE   xst0[7] = {0.,/* not used : index 0 */

1.900000,   2.40000,
2.530445,   0.60000,
3.912490,   0.15000,

};


    static DOUBLE ugloc[7] = {0.,/* not used : index 0 */

1.50,  0.05,
1.50,  0.05,
1.50,  0.05,

};
     static DOUBLE ogloc[7] = {0.,/* not used : index 0 */

5.00, 20.00,
5.00, 10.00,
5.00,  5.00,

};
    

    /* name is ident of the example/user and can be set at users will       */
    /* the first static character must be alphabetic. 40 characters maximum */
    /* xst violates bounds : checks for automatic correction */
    strcpy(name,"statmatc");
     
    /* x is initial guess and also holds the current solution */

    silent = FALSE;
    analyt = FALSE;
    epsdif = 1.e-14;   /* gradients exact to machine precision */
    /* if you want numerical differentiation being done by donlp2 then:*/
    epsfcn   = 1.e-16; /* function values exact to machine precision */
    taubnd   = 10.0;
    /* bounds may be violated at most by taubnd in finite differencing */
    /*  bloc    = TRUE; */
    /* if one wants to evaluate all functions  in an independent process */
    difftype = 2; 
    
    nreset = n;
    
    
    del0 = 1.0e0;
    tau0 = 1.0e1;
    tau  = 0.1e0;
    for (i = 1 ; i <= n ; i++) {
        x[i] = xst0[i];
    }
    

    /*  set lower and upper bounds */
    big = 1.e20;
    for ( i = 1 ; i <= n ; i++ ) { low[i]=ugloc[i]; up[i]=ogloc[i];}

    /*low[3] = up[3] = 1.0;*/
    /* 1 linear equality constraint*/

    /* low[8] = 0.0; */
    /* up[8] = big;  */
    /* low[9] = 0.0; */
    /* up[9] = big;  */
    /* 1 nonlinear equality constraint*/

    /* store coefficients of linear constraints directly in gres */

    /* gres[1][1] = 1.0; */
    /* gres[2][1] = 1.0; */
    /* gres[3][1] = 1.0; */
    /* gres[4][1] = 1.0; */
    /* gres[5][1] = 1.0; */
    /* gres[6][1] = 1.0; */
    
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
    te2=TRUE;
    te3=TRUE;
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
    #include <stdio.h>
    #include <stdlib.h>
    #undef   X

    static int i; 
    static double soq;
    double num;
    double mad;
    int nn;

    FILE *fp;
    FILE *fq;  
    FILE *fr;

    fp = fopen("params.in", "w");
    if (fp == NULL) 
    {
      printf("I couldn't open params.in for writing.\n");
      exit(0);
    }

    for (i=1; i<=n; ++i)
    {
      fprintf(fp, "%.14f x%u  \n", x[i], i);
    }

    fclose(fp);
    system("./driver.sh");

    fq = fopen("results.out", "r");
    if (fq == NULL) 
    {
      printf("I couldn't open results.out for reading.\n");
      exit(0);
    }

    num=0.0;
    mad=0.0;
    soq=0.0;
    nn=0;
    while ( fscanf(fq, "%lf", &num ) == 1 )  
    {
       mad+=fabs(num);
       soq+=num*num;
       nn+=1;
    } 
    fclose(fq);
    printf("SOQ: %f\n",soq);
    printf("MAD: %f\n",mad/(double)nn);

    /* Note the SOQ's to a file */
    fr = fopen("SOQ.out", "a");
    if (fr == NULL)
    {
      printf("I couldn't open SOQ.out for writing.\n");
      exit(0);
    }
    fprintf(fr, "SOQ: %f\n",soq);
    fprintf(fr, "MAD: %f\n",mad/(double)nn);
    fclose(fr);

    *fx = soq;

    return;
}

/* **************************************************************************** */
/*                          gradient of objective function                      */
/* **************************************************************************** */
void egradf(DOUBLE x[],DOUBLE gradf[]) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X

    static int i;
    static int j;
/*    static double sum; */
/*    sum=0.0; */
/*    for ( i=1; i<=2; i++) */
/*    { */
/*      sum+= pow( x[i] ,2); */
/*    } */
/*    *fx = sum; */
    static double soq;
    static double grad_soq;
    double num;
    double h;

    FILE *fp1;
    FILE *fp2;
    FILE *fq1;
    FILE *fq2;

    h=0.0001;

    printf("There shouldn't be an analytic gradient call.\n");

    for (i=1; i<=6; ++i)
    {
   
      grad_soq=0.0; 
      fp1 = fopen("params.in", "w");
      if (fp1 == NULL)
      {
        printf("I couldn't open params.in for writing.\n");
        exit(0);
      }

      for (j=1; j<=6; ++j)
      { 
        if (j == i)
        {
          fprintf(fp1, "%f x%u\n", x[j]+h, j);
        }
        else
        {
          fprintf(fp1, "%f x%u\n", x[j], j);
        }
      }

      fclose(fp1);
      printf("Calculating x[%d]+h.\n",i);
      system("./driver.sh");
   
      fq1 = fopen("results.out", "r");
      soq=0.0;
      while ( fscanf(fq1, "%lf", &num ) == 1 )
      {
        soq+=num;
      }
      fclose(fq1);

      grad_soq=soq/(2.0*h);


      fp2 = fopen("params.in", "w");
      if (fp2 == NULL)
      {
        printf("I couldn't open params.in for writing.\n");
        exit(0);
      }

      for (j=1; j<=6; ++j)
      {
        if (j == i)
        {
          fprintf(fp2, "%f x%u\n", x[j]-h, j);
        }
        else
        {
          fprintf(fp2, "%f x%u\n", x[j], j);
        }
      }

      fclose(fp2);
      printf("Calculating x[%d]-h.\n",i);
      system("./driver.sh");

      fq2 = fopen("results.out", "r");
      soq=0.0;
      while ( fscanf(fq2, "%lf", &num ) == 1 )
      {
        soq+=num;
      }
      fclose(fq2);

      grad_soq=grad_soq-(soq/(2.0*h));

      gradf[i]=grad_soq;

    }

    return;
}

/* **************************************************************************** */
/*  two nonlinear constraints */
/* **************************************************************************** */


void econ(INTEGER type ,INTEGER liste[], DOUBLE x[],DOUBLE con[],
              LOGICAL err[]) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X

    return;
}

/* **************************************************************************** */
/* **************************************************************************** */
void econgrad(INTEGER liste[] ,INTEGER shift ,  DOUBLE x[],
               DOUBLE **grad) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X

    printf("There shouldn't be an analytic gradient call.\n");

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
