--[[
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
/*    DATA:  getStarted data from Example 1 of logistic action  */
/* LANGUAGE: Lua                                                */
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
these data.  A table of measures of association between predicted
probabilities and the observed responses is displayed.  The
Receiver Operating Characteristic Curve is produced and the
underlying classificiation table is shown.
*/
--]]

s:loadtable{casLib="casuser", path="getStarted.csv"}

s:loadactionset{actionset="regression"}
m=s:logistic{
   table='getStarted',
   class={'C'},
   model={depvar='y',
          effects={'C', 'x2', 'x8'}},
   store={name='myModel', replace=true} }

m=s:logisticAssociation{
   restore='myModel',
   table='getStarted'}

print(m.Association)

m=s:logisticAssociation{
      restore='myModel',
      table='getStarted',
      ctable=true,
      fitData='true',
      casOut={name='ctable2', replace=true},
      tpf='tpf',
      fpf='fpf'}

a=s:fetch{table={name='ctable2', orderby='Pred'}, to=5}
print(a)

