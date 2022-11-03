--[[
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

The data consists of 100 observations on a dichotomous response
variable y, a character variable C, and 10 continuous variables
x1--x10.  A main effects binary logistic regression model is fit to
these data, and the resulting model is stored.  The stored model is
then used to produce SAS DATA step code for scoring new data tables.
--]]

s:loadtable{casLib="casuser", path="getStarted.csv"}

s:loadactionset{actionset="regression"}
m=s:logistic{
   table='getStarted',
   class={'C'},
   model={depvar='y',
          effects={'C', 'x2', 'x8'}},
   store={name='myModel', replace=true}}

m=s:logisticCode{
   restore='myModel',
   pCatAll='true',
   casOut={name='code1', replace=true} }
s:loadactionset{actionset="dataStep"}
n=s:runCodeTable{
   codetable='code1',
   table='getStarted',
   casOut='scored'}

a=s:fetch{table={name='scored', orderby='id'}, to=5}
print(a)

