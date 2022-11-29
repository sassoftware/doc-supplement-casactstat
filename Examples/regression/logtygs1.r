if(FALSE){
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
/*    DATA:                                                     */
/* LANGUAGE: R                                                  */
/*     MISC:                                                    */
/*                                                              */
/****************************************************************/

/*
The data consists of 100 observations on a dichotomous response
variable y, a character variable C, and 10 continuous variables
x1--x10.  A main effects binary logistic regression model is fit to
these data, and the resulting model is stored.  The stored model is
then used to produce Wald tests of the parameters.
*/
}

m <- cas.read.csv(s, "getStarted.csv", casOut=list(name="getStarted"))

m <- cas.builtins.loadActionSet(s, actionset='regression')
m <- cas.regression.logistic(s,
   table='getStarted',
   class='C',
   model=list(depvar='y',
              effects=list('C', 'x2', 'x8')),
   store=list(name='myModel',replace=TRUE)
)

m <- cas.regression.logisticType3(s,
   restore='myModel'
)

print(m$ModelAnova)

