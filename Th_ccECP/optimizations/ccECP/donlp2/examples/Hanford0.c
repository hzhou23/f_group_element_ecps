/* ****************************************************************************/
/*                                 user functions                            */
/* **************************************************************************/
#include "o8para.h"
main() {
    void donlp2(void);

    donlp2();

    exit(0);
}


/* **************************************************************************** */
/*                                 user functions                               */
/* **************************************************************************** */

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
    
     n      = 41;
    nlin   =  36;
    nonlin =  0;
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
    
    static INTEGER  i,j;
  static DOUBLE xst0[42] = {0./*f*/,464290.9, 110126.8, 7512.0, 8342.0, 
   0., 0., 0., 0., 0., 0./*p*/, 0.6406131, 0.10964855, 0.04063912, 
  0.00812782, 0.00540127, 0.00280372, 0.08672442, 0.04438228 , 
  0.01111813 ,0.0406511 ,0.00190768 ,0.00052885 ,0.00542653 ,0.00202743 ,
   0. /*g*/,475493.9 ,112537.4 ,41710.0 ,8342.0 ,5543.6 ,2877.6 ,89009.7 ,
  45551.8 ,11411.1 ,41722.3 ,
  1957.95 ,542.788 ,5569.52 ,2080.857 ,0. ,/*G*/1026351.02 }; 

    static DOUBLE ugloc[11] = {0.,/* not used : index 0 */
                              42.e-2, 5.e-2, 5.e-2, 1.e-2, 0.0, 
                 0.0, 2.e-2 ,0.0 ,0.0, 1.e-2 };

    static DOUBLE ogloc[11] = {0.,/* not used : index 0 */
                              57.e-2 ,2.e-1, 2.e-1, 7.e-2,  1.e-2, 
                              8.e-2, 15.e-2, 15.e-2, 13.e-2, 10.e-2 };

    static DOUBLE  c_1 = 3.e0,c_2 = 8.e-2,c_3 = 225.e-3,c_4 = 18.e-2 ,
         c_5=18.e-2 ,ViscMin = 2.e0,ViscMax = 10.e0,
                   kMin =18.e0,kMax = 50.e0,maxpct = 10.e0,maxmcc = 28.e0 ;

    
    static DOUBLE w_1[16] = {0., 72.e-3, 26.e-3, 105.e-3 ,0. ,61.e-3 ,
       40.e-3 ,328.e-3 ,148.e-3 ,2.e-3 ,217.e-3 ,16.e-3 ,6.e-3 ,
       42.e-3 ,1.e-3 ,0. };
    static DOUBLE w_2[16] = {0., 92.e-3, 0., 264.e-3 ,0. ,
        12.e-3 ,0. ,323.e-3 ,157.e-3 ,57.e-3 ,96.e-3 ,7.e-3 ,1.e-3 ,
        1.e-3 ,18.e-3 ,0. };
    static DOUBLE w_3[16] = {0., 22.e-3, 6.e-3, 120.e-3 ,0. ,
        10.e-3 ,3.e-3 ,392.e-3 ,212.e-3 ,63.e-3 ,173.e-3 ,5.e-3 ,
        1.e-3 ,21.e-3 ,9.e-3 ,0. };
    
    DOUBLE Waste[16];
    
    
    for (i = 1; i <= 15; i++) 
   { Waste[i] = 59772 * w_1[i] +  40409 * w_2[i] + 143747 * w_3[i];}

    /* name is ident of the example/user and can be set at users will       */
    /* the first static character must be alphabetic. 40 characters maximum */

    strcpy(name,"Hanford0Waste");
     
    /* x is initial guess and also holds the current solution */
    /* problem dimension n = dim(x), nlin=number of linear constraints
       nonlin = number of nonlinear constraints  */
    
    analyt = TRUE;
    epsdif = 1.e-16;   /* gradients exact to machine precision */
    /* if you want numerical differentiation being done by donlp2 then:*/
    /* epsfcn   = 1.e-16; *//* function values exact to machine precision */
    /* taubnd   = 5.e-6; */
    /* bounds may be violated at most by taubnd in finite differencing */
    /*  bloc    = TRUE; */
    /* if one wants to evaluate all functions  in an independent process */
    /* difftype = 3; *//* the most accurate and most expensive choice */
    
   /* for(i = 1; i <= 41; i++) {xst0[i] = 1000.0;} */
    nreset = n;
    del0 = 1.0e-6;
    tau0 = 1.e-2;
    tau  = 0.1e0;
    for (i = 1 ; i <= n ; i++) {
        x[i] = xst0[i]; xsc[i]=1.0;
    }
    for ( i=26; i<=n; i++) 
    {
       xsc[i] = 1.0e4;
    }

    /*  set lower and upper bounds */
    big = 1.e20;
    for ( i = 1 ; i <= 10 ; i++ ) { low[i]=0.;} /* f(i) */
    for ( i = 1 ; i <= 10; i++ ) {low[i+10]=ugloc[i];}  /* p(i) */
    for ( i = 11 ; i <= 15; i++ ) {low[i+10]=0.;}    /* p(i)  other*/
    for ( i = 26 ; i <= 40; i++ ) {low[i]=0.;}     /* g(i) */
    low[41]= 250000.e0;  /* G */
    for( i = 1 ; i <= 10; i++) 
         {low[i+41]= -Waste[i];} /* f(i)-g(i) = -Waste(i) */
    low[52] = Waste[11];
    low[53] = Waste[12];
    low[54] = Waste[13];
    low[55] = Waste[14];
    low[56] = Waste[15];
    /*5 linear crystallinity and  5 solubility constraints */
    for ( i = 57 ; i <= 66 ; i++ ) {low[i]=0.;} /*-big*/
    for ( i = 67; i <= 76; i++ ) {low[i]=0.;}  /*10 f(i) >0 */
    low[77]= -(Waste[11]+Waste[12]+Waste[13]+Waste[14]+Waste[15]);  
        /* sumg(i)-G=*/ 

    
    for ( i = 1 ; i <= 10 ; i++ ) { up[i]=900000.e0;} /* f(i) */
    for ( i = 1 ; i <= 10; i++ ) {up[i+10]=ogloc[i];}  /* p(i) */
    for ( i = 11 ; i <= 15; i++ ) {up[i+10]=1.e0;}    /* p(i)  other*/
    for ( i = 26 ; i <= 40; i++ ) {up[i]=1000000.e0;}     /* g(i):1 to 15 */
    up[41]=10000000.e0; /* G */
    for ( i = 1 ; i <= 10; i++ ) {up[41+i]= -Waste[i];}  
    /* f(i)-g(i) = -Waste(i) */
    up[52] = Waste[11];
    up[53] = Waste[12];
    up[54] = Waste[13];
    up[55] = Waste[14];
    up[56] = Waste[15];
    
  /*5 linear crystallinity and solubility constraints */
    up[57]=2.e0;  /*   p(Sio2)>p(Al2o3)*c1  oder  p(Sio2)-p(Al2o3)*c1 >0   */
    up[58]=c_2;           /*   p(Mgo)+p(Cao)<c2          
                          */
    up[69]=c_3;           /*   p(Fe2o3)+p(Al2o3)+p(Zro2)+p(other)<c3
               */
    up[60]=c_4;           /*   p(Al2o3)+p(Zro2)<c4                         */
    up[61]=c_5;           /*   p(Mgo)+p(Cao)+p(Zro2)< c5                  */
    /* 5 linear solubility constraints */
    up[62]=5.e-3;        /*   p(cr2o3) <0.005                             */
    up[63]=17.e-3;        /*   p(F)< 0.017                               */
    up[64]=1.e-2;         /*   p(p2o5)<0.01                               */
    up[65]=5.e-3;         /*   p(So3)<0.005                                */
    up[66]=25.e-3;        /*   p(nobek mental)< 0.025   */
    for ( i = 67; i <= 76; i++ ) {up[i]=900000.e0;}  /*10 f(i) >0 */
    up[77]=-(Waste[11]+Waste[12]+Waste[13]+Waste[14]+Waste[15]);
        /* sumg(i)-G=0*/
            /*  19 nonlin   */
            /*  4 nonlinear inequality constraints :*/
    /* store coefficients of linear constraints directly in gres */
   
    for ( i = 1 ; i<= 36 ; i++ )
    { 
      for  ( j = 1 ; j <= 41 ; j++ )
        {
          gres[j][i] = 0.0 ;
        }
    }
  /*  f(i)-g(i)=-Waste[i]  */
    for ( i = 1 ; i <= 10; i ++)    
        {
          for ( j = 1; j<= 10 ; j++)
             {
               gres[j][i] = 1;
             }
        }
   for ( i = 1 ; i <= 10; i ++)
        {
          for ( j = 26; j<= 35 ; j++)
             {
               gres[j][i] = -1;
             }
       }
    for ( i = 11 ; i <= 15; i ++) /*g(i)=Waste(i) */
        {
          for ( j = 36; j<= 40 ; j++)
             {
               gres[j][i] = 1;
             }
       }
    
    /*5 linear crystallinity and  5 solubility constraints */ 
  
   gres[11][16]=1;
   gres[18][16]=-c_1;
   gres[16][17]=1;
   gres[15][17]=1;
   gres[17][18]=1;
   gres[18][18] = 1;
   gres[19][18] = 1;
   gres[20][18] = 1;
   gres[18][19] = 1;
   gres[19][19] = 1;
   gres[16][20] = 1;
   gres[15][20] = 1;
   gres[19][20] = 1;
   gres[21][21] = 1;
   gres[22][22] = 1;
   gres[23][23] = 1;
   gres[24][24] = 1;
   gres[25][25] = 1;
   
  
    /* f(i)>0*/
    for ( i = 26 ; i <= 35; i ++)    
        {
          for ( j = 1; j<= 10 ; j++)
             {
               gres[j][i] = 1;
             }
         }
   /* sum g(i) - G = -(Waste[11]+ ...+Waste[15])*/
   for(j = 26; j<=35; j++) 
   { gres[j][36] = 1;}
   
    gres[41][36] = -1;
   
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
   /*  te3=TRUE;  */ 
   
    return;
}

/* **************************************************************************** */
/*  the user may add additional computations using the computed solution here   */
/* **************************************************************************** */
void solchk(void) {
    #define  X extern
    #include "o8comm.h"
    #include "o8cons.h"
    #undef X 
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
     
    *fx = 1.e0*x[1]+1.e0*x[2]+1.e0*x[3]+1.e0*x[4]+1.e0*x[5]+1.e0*x[6]+1.e0*x[7]
+1.e0*x[8]+1.e0*x[9]+1.e0*x[10];
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
    static DOUBLE a[42] = {0.,/* not used : index 0 */
                             1.e0, 1.e0, 1.e0, 1.e0, 1.e0,
                             1.e0, 1.e0, 1.e0, 1.e0, 1.e0 ,0. ,0. ,0. ,0.,
0.,0. ,0. ,0. ,0.,0.,0. ,0. ,0. ,0.,0.,0. ,0. ,0. ,0.,0.
,0. ,0. ,0. ,0.,0.,0. ,0. ,0. ,0.,0.,0. };
    for(j = 1; j<= 41; j++) {   gradf[j] = a[j]; }


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
    static INTEGER i,j,k;
    static INTEGER liste_loc[20];
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
    static DOUBLE t,t1,t3,t4;
    static INTEGER liste_loc[22];
   
  /*  Linear coefficients of viscosity model */       
    static DOUBLE Linear_coe_visc[11] = { 0.0, 9.47e0, -14.5915e0, -11.0184e0, 
-33.6984e0, -5.3832e0,-1.5024e0, -3.9269e0, 11.4124e0, 9.9016e0, -0.3041e0 };

    /*  Linear coefficients of electrical conductivity model */
    static DOUBLE Linear_coe_cond[11] = {0.0, 0.9121e0, 6.0920e0, 13.7875e0, 
100.4912e0, -0.9357e0, -0.9450e0,1.3811e0, -0.7546e0, -0.6340e0, 2.1391e0 };
    
    /*   Linear coefficients of Durability (PCT) model (for Boron)  */
    static DOUBLE Linear_coe_PCT[11] = {0.0, -2.1186e0, -28.1878e0, 15.6606e0, 
20.2263e0, -8.4922e0, -36.0019e0,2.0287e0, -19.0994e0, -4.1143e0, 6.7180e0 };

    /*   Linear coefficients of Durability (MCC) model (for Boron) */
    static DOUBLE Linear_coe_MCC[11] = {0.0, 3.4256e0, -5.5002e0, 26.0694e0, 6.4803e0, 
5.4435e0, 4.5177e0, 3.0065e0,-8.8350e0, -2.3333e0,  -0.5088e0 }; 

    /*  bv Cross term coefficients of viscosity model :                  */
    static DOUBLE  bv_2_7 = 36.5869e0;                 /*BV('B2O3','Fe2O3') = 36.5869;*/
    static DOUBLE  bv_7_8 = 34.8765e0;                 /*BV('Fe2O3','Al2O3') = 34.8765;*/
    static DOUBLE  bv_8_9 = -97.3354e0;                /*BV('Al2O3','ZrO2') = -97.3354;*/
    static DOUBLE  bv_2_2 = 29.4816e0;                 /*BV('B2O3','B2O3') = 29.4816;*/
   
   /*  be Cross term coefficients of electrical conductivity model */
   static DOUBLE  be_1_4 = -50.3716e0;                 /*BE('SiO2','Li2O') = -50.3716;*/
   static DOUBLE  be_3_4 = -101.2283e0;                /*BE('Na2O','Li2O') = -101.2283;*/
   static DOUBLE  be_2_2 = -23.4896e0;                 /*BE('B2O3','B2O3')= -23.4896;*/

   /*Cross term coefficients of Durability (PCT) model for Boron */
   static DOUBLE bdpb_2_2 = 166.5814e0;              /*BDPB('B2O3','B2O3') = 166.5814;*/
   static DOUBLE bdpb_1_6 = 93.5007e0;               /* BDPB('SiO2','MgO') = 93.5007;*/

  /* Cross term coefficients of Durability (MCC) model (for Boron);*/
  static DOUBLE bdmb_2_2 = 55.6853e0;                 /*BDMB('B2O3','B2O3') = 55.6853;*/
  static DOUBLE bdmb_1_3 = -38.8016e0;                /*BDMB('SiO2','Na2O') = -38.8016;*/

    
    return;
}


/* **************************************************************************** */
/*                        user functions (if bloc == TRUE)                      */
/* **************************************************************************** */
void eval_extern(INTEGER mode) {
    #define  X extern
    #include "o8comm.h"
    #include "o8fint.h"
    #include "o8cons.h"
    #undef X     
    return;
    }



