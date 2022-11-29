if(FALSE){
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
/* LANGUAGE: R                                                  */
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
}

m <- cas.read.csv(s, "getStarted.csv", casOut=list(name="getStarted"))

m <- cas.builtins.loadActionSet(s, actionset='regression')
m <- cas.regression.logistic(s,
   table='getStarted',
   class='C',
   model=list(depvar='y',
              effects=list('C', 'x2', 'x8')),
   store=list(name='myModel', replace=TRUE)
)

m <- cas.regression.logisticCode(s,
   restore='myModel',
   pCatAll=TRUE,
   casOut=list(name='code1', replace=TRUE)
)
m <- cas.builtins.loadActionSet(s, actionset='dataStep')
m <- cas.dataStep.runCodeTable(s,
   codeTable='code1',
   table='getStarted',
   casOut='scored'
)

cas.table.fetch(s, table='scored', orderby='id', to='5')

