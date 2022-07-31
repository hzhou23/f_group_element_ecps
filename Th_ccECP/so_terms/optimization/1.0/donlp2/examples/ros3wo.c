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
    
    n      = 17;
    nlin   =  0;
    nonlin =  11;
    iterma = 400;
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
    static DOUBLE   xst0[18] = {0.,/* not used : index 0 */
             0.223648, 0.40649, -0.30581117, -0.0700905,0.66027818,
             0.0408217,-0.49262194,0.1330675,0.748794, -0.0635139,
             -0.22026726, -0.02870877, 0.78111, 0.3840788,-0.2303918278,
             0.5243721776,0.321940841};
                                  
    /* name is ident of the example/user and can be set at users will       */
    /* the first static character must be alphabetic. 40 characters maximum */

    strcpy(name,"ros3wo");
     
    /* x is initial guess and also holds the current solution */
    /* problem dimension n = dim(x), nlin=number of linear constraints
       nonlin = number of nonlinear constraints  */
    
    analyt = FALSE;
    epsdif = 1.e-13;   /* gradients exact to machine precision */
    /* if you want numerical differentiation being done by donlp2 then:*/
     epsfcn   = 1.e-16; /* function values exact to machine precision */
    /* taubnd   is no longer in use  */
    /*  bloc    = TRUE; */
    /* if one wants to evaluate all functions  in an independent process */
     difftype = 3; /* the most accurate and most expensive choice */
    
    nreset = n;
    
    
    del0 = 0.2e0;
    tau0 = 1.e01;
    tau  = 0.1e0;
    delmin= 1.e-8;
    epsx=1.e-8;
    for (i = 1 ; i <= n ; i++) {
        x[i] = xst0[i];
    }
    

    /*  set lower and upper bounds */
    big = 1.e20;
    low[1] = 0.2236478;  /* for gamma 8/
    up[8] = 0.9999999;   /* a21 <1 */
    for ( i=14; i<=17; i++ ) {
    /* the b[i] */
      low[i] = -1.0;
      up[i]=1.0;
    }
    /* eleven equality constraints of type =0 */
    for ( i = 18; i<=28 ; i++ ) {low[i]=up[i]=0.0;}

    
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
    DOUBLE gam,gam21,gam31,gam32,gam41,gam42,gam43,al21,al31,al32,
           al41,al42,al43,b1,b2,b3,b4,det;
    DOUBLE G[5][5],A[5][5],B[5][5],e[5],AA[5][5],AB[5][5],AG[5][5],
           be[5],Ae[5],Be[5],Bb[5],Ab[5], AAe[5],ABe[5],Be2[5],AAe2[5],
           ABe2[5],mat[5][5];
    DOUBLE p[5];
    INTEGER i,j,z;
    /* index 0 not used here */
    void lu_det( DOUBLE *det , DOUBLE a[][5] );

    gam=x[1];
    gam21=x[2];
    gam31=x[3];
    gam32=x[4];
    gam41=x[5];
    gam42=x[6];
    gam43=x[7];
    al21=x[8];
    al31=x[9];
    al32=x[10];
    al41=x[11];
    al42=x[12];
    al43=x[13];
    b1=x[14];
    b2=x[15];
    b3=x[16];
    b4=x[17];
    for ( i=1; i<=4; i++ ){
      e[i] = 1.0 ;
      for (j=1; j<=4; j++ ) {
         G[i][j] = 0.0 ;
         A[i][j] = 0.0 ;
         AG[i][j] = 0.0 ;
      }
      G[i][i] = gam;
    }
    G[2][1] = gam21;
    G[3][1] = gam31;
    G[3][2] = gam32;
    G[4][1] = gam41;
    G[4][2] = gam42;
    G[4][3] = gam43;
    A[2][1] = al21;
    A[3][1] = al31;
    A[3][2] = al32;
    A[4][1] = al41;
    A[4][2] = al42;
    A[4][3] = al43;
    for ( i=1; i<=4; i++ ){
      for (j=1; j<=4; j++) {
         B[i][j] = A[i][j] + G[i][j] ;
      }
    }
    for ( z=-2; z<=2; z++ ){
    /* compute det for z */
      for ( i=1; i<=4; i++ ) {
        for ( j=1; j<=4; j++ ) {
           mat[i][j] = z*(x[13+j]-B[i][j]);
           if ( i==j ) mat[i][j] +=1.0;
        }
      }
      /* compute the determinant of mat */

      lu_det(&det,mat);
      /* mat gets overwritten */
      p[z+2]=det;
    } /* end loop for z */
    /* divided differences in p*/
    for ( i=1; i<=4; i++) {
      for ( j=4; j>=i; j--) {
         p[j] = (p[j]-p[j-1])/i;
      }
    }
    *fx=pow(p[4],2);  
    /* the divided difference of order 4 should become zero */
    return;
}
void lu_det( DOUBLE *det , DOUBLE a[][5] )
{
int i,j,k,ip,jp,k0,n,vz;
int zpvt[5], cpvt[5]  ;
double row[5], col[5] , pivot, factor , term , norma , sum ;      
norma = 0.0e0 ;
pivot = 0.0e0 ;
ip =  -1 ; 
jp =  -1 ; 
n =  4;
vz = 1 ;
for ( i=1 ; i<= n ; i++ )
 {
   zpvt[i] = i ;
   cpvt[i] = i ;
   for ( j=1; j<= n ; j++ )
     {
       term = a[i][j] ;
       norma = norma+fabs ( term ) ;
       if ( fabs(term)  >  fabs(pivot) )
         {
           pivot=term ;
           ip = i ;
           jp = j ;
         }
     }
  }   
      
if ( ip < 0 ) {
   *det = 0.0 ;
   return ;
}
/* gauss - elimination */

for ( i=1 ; i<=n-1 ; i++ )
  {
/* pivot position is (ip,jp) with value pivot */

    if ( fabs( pivot ) <= 2.2e-16*norma )
      {
         *det = 0.0 ;
         return ;
      }
    if ( ip != i )
      {
/* row interchange */
         vz = -vz ;
         j = zpvt[ip];  zpvt[ip] = zpvt[i]; zpvt[i] = j ;
         for ( j=1 ; j<= n ; j++ )
           {
             term = a[i][j] ; a[i][j] = a[ip][j] ;
             a[ip][j] = term ;
           }
      }
    if ( jp != i )
      {
/* column interchange */
          vz = -vz ;
         j = cpvt[jp]; cpvt[jp] = cpvt[i]; cpvt[i] = j ;
         for  ( j=1;j<=n; j++ )
           {
              term = a[j][i] ;  a[j][i] = a[j][jp];
              a[j][jp] = term ;
           }
       }
/* save divisions where possible */
    pivot = 1.0e0/pivot ;
    for ( j=i+1 ; j<=n ; j++ )
/* store multipliers  column in col and elimination row in row */
      {
         a[j][i] = col[j] = a[j][i]*pivot ;
         row[j] = a[i][j] ;
      }
    pivot = 0.0e0 ;
    ip = -1;
    jp = -1;
/* eliminate and search for the next pivot position */
    for ( j=i+1; j<=n; j++ )
      {
        factor=col[j];
        for  (k=i+1; k<=n; k++ )
           {
/* an axpy operation for row j */
             a[j][k] = term = a[j][k]-row[k]*factor;
             if ( fabs ( term ) > fabs ( pivot ) )
               {
                 pivot = term ;
                 ip = j ;
                 jp = k ;
               }
           }
      }
/* end elimination loop */
  }
  *det = vz ;
  for ( i=1; i<=n; i++ )
  {
    *det *= a[i][i] ;
  }
  return;
}

/***************************************************************************** */
/*                          gradient of objective function                      */
/* **************************************************************************** */
void egradf(DOUBLE x[],DOUBLE gradf[]) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X

    /* not used here */    
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
    /* eleven nonlinear equality constraints in con */
    DOUBLE gam,gam21,gam31,gam32,gam41,gam42,gam43,al21,al31,al32,
           al41,al42,al43,b1,b2,b3,b4,be;
    DOUBLE G[5][5],A[5][5],B[5][5],e[5],AA[5][5],AB[5][5],AG[5][5],
           Ae[5],Ae2[5],Be[5],Bb[5],Ab[5], AAe[5],ABe[5],Be2[5],AAe2[5],
           ABe2[5],mat[5][5];
    DOUBLE b[5],p[5],sum[12];
    INTEGER z;
    /* index 0 not used here */


    gam=x[1];
    gam21=x[2];
    gam31=x[3];
    gam32=x[4];
    gam41=x[5];
    gam42=x[6];
    gam43=x[7];
    al21=x[8];
    al31=x[9];
    al32=x[10];
    al41=x[11];
    al42=x[12];
    al43=x[13];
    b1=x[14];
    b2=x[15];
    b3=x[16];
    b4=x[17];
    for ( i=1; i<=4; i++ ){
      e[i] = 1.0 ;
      for (j=1; j<=4; j++ ) {
         G[i][j] = 0.0 ;
         A[i][j] = 0.0 ;
         AG[i][j] = 0.0 ;
      }
      G[i][i] = gam;
    }
    G[2][1] = gam21;
    G[3][1] = gam31;
    G[3][2] = gam32;
    G[4][1] = gam41;
    G[4][2] = gam42;
    G[4][3] = gam43;
    A[2][1] = al21;
    A[3][1] = al31;
    A[3][2] = al32;
    A[4][1] = al41;
    A[4][2] = al42;
    A[4][3] = al43;
    for ( i=1; i<=4; i++ ){
      for (j=1; j<=4; j++) {
         B[i][j] = A[i][j] + G[i][j] ;
      }
    }
    b[1]=b1;
    b[2]=b2;
    b[3]=b3;
    b[4]=b4;
    for (i=1; i<=11; i++) err[i]=FALSE;
    AA[1][1] = b1;
    AA[1][2] = b2*(1.0-al21/b1);
    AA[1][3] = b3*(1.0-al31/b1);
    AA[1][4] = b4*(1.0-al41/b1);
    AA[2][1] = b1;
    AA[2][2] = b2;
    AA[2][3] = b3*(1.0-al32/b2);
    AA[2][4] = b4*(1.0-al42/b2);
    AA[3][1] = b1;
    AA[3][2] = b2;
    AA[3][3] = b3;
    AA[3][4] = b4*(1.0-al43/b3);
    for (i=1; i<=4; i++) { 
    AA[4][i] = b[i] ;
    AG[i][i] = -gam; 
    }
    AG[1][2] = -b2*gam21/b1;
    AG[1][3] = -b3*gam31/b1;
    AG[1][4] = -b4*gam41/b1;
    AG[2][3] = -b3*gam32/b2;
    AG[2][4] = -b4*gam42/b2;
    AG[3][4] = -b4*gam43/b3;
    for ( i=1; i<=4; i++ ){
       for ( j=1; j<=4; j++ ){
          AB[i][j] = AA[i][j]+AG[i][j];
       }
    }
    be=0.0;
    for ( i=1; i<=4; i++)
    {
      be += b[i];
      Ae[i]=0.0;
      Be[i]=0.0;
      Bb[i]=0.0;
      Ab[i]=0.0;
      AAe[i]=0.0;
      ABe[i]=0.0;
      for ( j=1; j<=4; j++){
        Ae[i] += A[i][j];
        Be[i] += B[i][j];
        Bb[i] += B[i][j]*b[j];
        Ab[i] += A[i][j]*b[j];
        AAe[i] += AA[i][j];
        ABe[i] += AB[i][j];
      }
      Ae2[i] = pow(Ae[i],2);
      Be2[i] = pow(Be[i],2);
      AAe2[i] = pow(AAe[i],2);
      ABe2[i] = pow(ABe[i],2);
    }
    con[1]=be-1.0;
    for (i=1; i<=11; i++){
      sum[i]=0.0;}
    for (j=1; j<=4; j++){
      sum[2] += b[j]*Ae[j];
      sum[3] += b[j]*Be[j];
      sum[4] += b[j]*Ae2[j];
      sum[5] += Ab[j]*Ae[j];
      sum[6] += Ab[j]*Be[j];
      sum[7] += Bb[j]*Ae[j];
      sum[8] += Bb[j]*Be[j];
      sum[9] += b[j]*AAe2[j];
      sum[10] += b[j]*ABe2[j];
      sum[11] += b[j]*Be2[j];
     }
     con[2]=sum[2]-0.5;
     con[3]=sum[3]-0.5;
     con[4]=sum[4]-1.0/3.0;
     con[5]=sum[5]-1.0/6.0;
     con[6]=sum[6]-1.0/6.0;
     con[7]=sum[7]-1.0/6.0;
     con[8]=sum[8]-1.0/6.0;
     con[9]=sum[9]-1.0/3.0;
     con[10]=sum[10]-1.0/3.0;
     con[11]=sum[11]-1.0/3.0; 




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

    /* not used here */
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

