--[[
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
/*    DATA:                                                     */
/* LANGUAGE: Lua                                                */
/*     MISC:                                                    */
/*                                                              */
/****************************************************************/

/*
The data consists of 100 observations on a dichotomous response
variable y, a character variable C, and 10 continuous variables
x1--x10.  A main-effects binary logistic regression model is fit to
these data.  A table of odds ratios is displayed.
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

m=s:logisticOddsRatio{
   restore='myModel',
      oddsratios={'C','x2'}};

print(m.OddsRatios)

s:loadactionset{actionset="regression"}
m=s:logistic{
   table='getStarted',
   class={'C'},
   model={depvar='y',
          effects={{'C', 'x2', 'x8'},interaction='BAR'}},
   store={name='myModel2', replace=true} };

m=s:logisticOddsRatio{
   restore='myModel2',
      oddsratios={'C','x2'}};

m=s:logisticOddsratio{
   restore='myModel2',;
   oddsratios={{var='x2',unit={5,10},at={{var='C',level={'A','B'}},
                                         {var='x8',values=1}}} } };

m=s:logisticOddsratio{
   restore='myModel2',
   oddsratios={'x2'},
   unit={{var='x2',value={5,10}}},
   at={{var='C',level={'A','B'}},
       {var='x8',values=1}} };

