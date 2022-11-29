/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*     NAME: logasgs1                                           */
/*    TITLE: Example for logisticAssociation Action             */
/*     DESC: Binary Logistic Regression                         */
/*  PRODUCT: VIYA Statistics                                    */
/*   SYSTEM: ALL                                                */
/*     KEYS: Logistic regression analysis,                      */
/*           Binary response data                               */
/*    PROCS: regression action set; logisticAssociation action  */
/*    DATA:                                                     */
/* LANGUAGE: PROC CAS                                           */
/*     MISC:                                                    */
/*                                                              */
/****************************************************************/

/*
The data consists of 100 observations on a dichotomous response
variable y, a character variable C, and 10 continuous variables
x1--x10.  A main effects binary logistic regression model is fit to
these data.  A table of measures of association between predicted
probabilities and the observed responses is displayed.  The
Receiver Operating Characteristic Curve is produced and the
underlying classificiation table is shown.
*/

title 'Binary Logistic Regression';

proc cas;
   regression.logistic
      table='getStarted',
      class={'C'},
      model={depvar='y',
             effects={'C', 'x2', 'x8'}},
      store={name='myModel', replace=true};
run;

proc cas;
   regression.logisticAssociation
      restore='myModel',
      table='getStarted';
run;

proc cas;
   regression.logisticAssociation
      restore='myModel',
      table='getStarted',
      ctable=true,
      fitData='true',
      casOut={name='ctable2', replace=true},
      tpf='tpf',
      fpf='fpf';
run;

proc print data=mycas.ctable2(obs=5);
run;

data ctable2;
   set mycas.ctable2;
proc sort data=ctable2;
   by pred;
run;
ods graphics on;
proc sgplot data=ctable2 aspect=1 noautolegend;
   title 'ROC Curve';
   xaxis values=(0 to 1 by 0.25) grid offsetmin=.05 offsetmax=.05;
   yaxis values=(0 to 1 by 0.25) grid offsetmin=.05 offsetmax=.05;
   lineparm x=0 y=0 slope=1 / lineattrs=(color=ligr);
   series x=FPF y=TPF;
   inset 'Area under the curve=0.7800' / position=bottomright;
run;

