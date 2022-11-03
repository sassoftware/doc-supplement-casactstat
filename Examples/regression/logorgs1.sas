/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*     NAME: logorgs1                                           */
/*    TITLE: Example for logisticOddsRatio Action               */
/*     DESC: Binary Logistic Regression                         */
/*  PRODUCT: VIYA Statistics                                    */
/*   SYSTEM: ALL                                                */
/*     KEYS: Logistic regression analysis,                      */
/*           Binary response data                               */
/*    PROCS: regression action set; logisticOddsRatio action    */
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
x1--x10.  A main-effects binary logistic regression model is fit to
these data.  A table of odds ratios is displayed.
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
   regression.logisticOddsRatio
      restore='myModel',
      oddsratios={'C','x2'};
run;

proc cas;
   regression.logistic
      table='getStarted',
      class={'C'},
      model={depvar='y',
             effects={{vars={'C', 'x2', 'x8'}, interaction='BAR'}}},
      store={name='myModel2', replace=true};

   regression.logisticOddsRatio
      restore='myModel2',
      oddsratios={'C','x2'};
run;

proc cas;
   regression.logisticOddsRatio
      restore='myModel2',
      oddsratios={{var='x2',unit={5,10},at={{var='C',level={'A','B'}}
                                            {var='x8',values=1}} }};
run;

proc cas;
   regression.logisticOddsRatio
      restore='myModel2',
      oddsratios={'x2'},
      unit={{var='x2',value={5,10}}},
      at={{var='C',level={'A','B'}},{var='x8',values=1}};
run;

