--[[
/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*     NAME: loglfex1                                           */
/*    TITLE: Example for logisticLackFit Action                 */
/*     DESC: Binary Logistic Regression                         */
/*  PRODUCT: VIYA Statistics                                    */
/*   SYSTEM: ALL                                                */
/*     KEYS: Logistic regression analysis,                      */
/*           Binary response data                               */
/*    PROCS: regression action set; logisticLackFit action      */
/*    DATA:                                                     */
/* LANGUAGE: Lua                                                */
/*     MISC:                                                    */
/*                                                              */
/****************************************************************/

/*
The data consists of 100 observations on a dichotomous response
variable y, a character variable C, and 10 continuous variables
x1--x10.  A main effects binary logistic regression model is fit to
these data.  The Hosmer-Lemshow test is performed.
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

m=s:logisticLackFit{
   restore='myModel',
   table='getStarted'}


print(m.LackFitPartition)
print(m.LackFitChiSq)

