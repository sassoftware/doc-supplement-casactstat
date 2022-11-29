/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*     NAME: logcodegs1                                         */
/*    TITLE: Example for logisticCode Action                    */
/*     DESC: Binary Logistic Regression                         */
/*  PRODUCT: VIYA Statistics                                    */
/*   SYSTEM: ALL                                                */
/*     KEYS: Logistic regression analysis,                      */
/*           Binary response data                               */
/*    PROCS: regression action set; logisticCode action         */
/*    DATA:                                                     */
/* LANGUAGE: PROC CAS                                           */
/*     MISC:                                                    */
/*                                                              */
/****************************************************************/

/*
The data consists of 100 observations on a dichotomous response
variable y, a character variable C, and 10 continuous variables
x1--x10.  A main effects binary logistic regression model is fit to
these data, and the resulting model is stored.  The stored model is
then used to produce SAS DATA step code for scoring new data tables.
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
   regression.logisticCode
      restore='myModel',
      pcatall=true,
      casOut={name='code1', replace=true};
   dataStep.runCodeTable / codeTable="code1" table="getStarted" casOut="scored";
quit;
proc print data=mycas.scored(where=(id<=5));
run;

