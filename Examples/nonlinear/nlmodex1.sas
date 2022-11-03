/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: nlmodex1                                            */
/*   TITLE: Example for nlmod action                            */
/* PRODUCT: VIYA Statistics                                     */
/*    KEYS: Segmented model                                     */
/*   PROCS: nonlinear action set, nlmod action                  */
/* SUPPORT: Raghavendra Rao Kurada (Raghu)                      */
/*                                                              */
/****************************************************************/

data mycas.a;
   input y x @@;
   datalines;
.46 1  .47  2 .57  3 .61  4 .62  5 .68  6 .69  7
.78 8  .70  9 .74 10 .77 11 .78 12 .74 13 .80 13
.80 15 .78 16
 ;

proc cas;
   nonlinear.nlmod
      table='a',
      parms={{name='alpha',vals=.45},
             {name='beta',vals=.05},
             {name='gamma',vals=-.0025}},
      nlmodCode='x0 = -.5*beta / gamma;
                 if (x < x0) then
                   yp = alpha + beta*x  + gamma*x*x;
                 else
                   yp = alpha + beta*x0 + gamma*x0*x0;',
      model={depvar='y',
             dist='residual',
             distparms='yp'},
      estimate={{label='join point', expression='-beta/2/gamma'},
                {label='plateau value c', expression='alpha-beta**2/(4*gamma)'}},
      predout={name='b'},
      predict={{label='predicted', expression='yp', pred='yp'}},
      id={'y','x'};
run;

