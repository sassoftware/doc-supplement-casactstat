/*****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                  */
/*                                                               */
/*     NAME: fasticags1                                          */
/*    TITLE: Example for fastIca Action                          */
/*  PRODUCT: VIYA Statistics                                     */
/*   SYSTEM: ALL                                                 */
/*     KEYS: Multivariate Analysis                               */
/*    PROCS: ica action set; fastIca action                      */
/*     DATA:                                                     */
/* LANGUAGE: PROC CAS                                            */
/*                                                               */
/*  SUPPORT: Ning Kang                                           */
/*     MISC:                                                     */
/*****************************************************************/

/* Example: Simulated Signal Data */

data mycas.sample;
   keep t x:;
   array S[200,3];     /* S: source signals */
   array A[3,3];       /* A: mixing matrix */
   array x[3] x1-x3;   /* X: mixed signals */

   N = 200;

   do i = 1 to 3;
      do j = 1 to 3;
         A[i,j] = 0.7*uniform(12345);
      end;
   end;

   do i = 1 to N;
      S[i,1] = cos(i/3);
      S[i,2] = 0.4*((mod(i,23)-11)/7)**5;
      S[i,3] = ((mod(i,29)-7)/11)-0.7;
   end;

   do i = 1 to N;
      t = i;
      do j = 1 to 3;
         x[j] = 0;
         do k = 1 to 3;
            x[j] = x[j] + S[i,k]*A[k,j];
         end;
      end;
      output;
   end;
run;

ods trace on;
proc cas;
   action ica.fastIca /
      table='sample',
      inputs={'x1', 'x2', 'x3'},
      method='symmetric',
      seed=345,
      displayOut={names={Demixing='demix'}},
      output={casOut={name='scores', replace=true},
              component='c', copyVars={'t'}};
run;

