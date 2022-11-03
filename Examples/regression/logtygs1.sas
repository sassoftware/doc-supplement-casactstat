/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*     NAME: logtype3gs1                                        */
/*    TITLE: Example for logisticType3 Action                   */
/*     DESC: Binary Logistic Regression                         */
/*  PRODUCT: VIYA Statistics                                    */
/*   SYSTEM: ALL                                                */
/*     KEYS: Logistic regression analysis,                      */
/*           Binary response data                               */
/*    PROCS: regression action set; logisticType3 action        */
/*    DATA:  getStarted data from Example 1 of logistic action  */
/* LANGUAGE: PROC CAS                                           */
/*                                                              */
/*  SUPPORT: Bob Derr                                           */
/*     MISC:                                                    */
/*                                                              */
/****************************************************************/

/*****************************************************************
Binary Logistic Regression
*****************************************************************/

/*
The data consists of 100 observations on a dichotomous response
variable y, a character variable C, and 10 continuous variables
x1--x10.  A main effects binary logistic regression model is fit to
these data, and the resulting model is stored.  The stored model is
then used to produce Wald tests of the parameters.
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
   regression.logisticType3
      restore='myModel';
run;

