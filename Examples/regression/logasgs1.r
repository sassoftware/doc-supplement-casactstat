if(FALSE){
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
/* LANGUAGE: R                                                  */
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

m <- cas.regression.logisticAssociation(s,
   restore='myModel',
   table='getStarted'
)

print(m$Association)

m <- cas.regression.logisticAssociation(s,
   restore='myModel',
   table='getStarted',
   ctable=TRUE,
   fitData=TRUE,
   casOut=list(name='ctable2', replace=TRUE),
   tpf='tpf',
   fpf='fpf'
)

cas.table.fetch(s, table='ctable2', orderby='Pred', to='5')

