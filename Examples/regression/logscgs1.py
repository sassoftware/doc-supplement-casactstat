"""
/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*     NAME: logscgs1                                           */
/*    TITLE: Example for logisticScore Action                   */
/*     DESC: Binary Logistic Regression                         */
/*  PRODUCT: VIYA Statistics                                    */
/*   SYSTEM: ALL                                                */
/*     KEYS: Logistic regression analysis,                      */
/*           Binary response data                               */
/*    PROCS: regression action set; logisticScore action        */
/*    DATA:                                                     */
/* LANGUAGE: Python                                             */
/*     MISC:                                                    */
/*                                                              */
/****************************************************************/

/*
The data consists of 100 observations on a dichotomous response
variable y, a character variable C, and 10 continuous variables
x1--x10.  A main effects binary logistic regression model is fit to
these data, and the resulting model is stored.  The stored model is
then used to produce predicted probabilities and other
observationwise statistics for a new data table.
*/
"""

s.upload_file('getStarted.csv')

s.loadactionset(actionset='regression')
m=s.logistic(
   table='getStarted',
   classvars='C',
   model={'depvar':'y',
          'effects':['C', 'x2', 'x8']},
   store={'name':'myModel', 'replace':'true'},
   output={'casOut':{'name':'out1','replace':'true'},
           'pred':'pred', 'resChi':'reschi', 'into':'into',
           'copyVars':['y', 'id']} )

print(m.OutputCasTables)

m=s.logisticScore(
   restore='myModel',
   table='getStarted',
   fitData='true',
   casOut={'name':'out2', 'replace':'true'},
   copyVars=['y', 'id'],
   pred='pred', resChi='reschi', into='into' )

a=s.fetch(table={'name':'out1','orderby':'id'}, to='5')
b=s.fetch(table={'name':'out2','orderby':'id'}, to='5')
print(a)
print(b)

