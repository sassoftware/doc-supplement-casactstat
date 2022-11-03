#***************************************************************/
#          S A S   S A M P L E   L I B R A R Y                 */
#                                                              */
#     NAME: logscgs1                                           */
#    TITLE: Example for logisticScore Action                   */
#     DESC: Binary Logistic Regression                         */
#  PRODUCT: VIYA Statistics                                    */
#   SYSTEM: ALL                                                */
#     KEYS: Logistic regression analysis,                      */
#           Binary response data                               */
#    PROCS: regression action set; logisticScore action        */
#    DATA:  getStarted data from Example 1 of logistic action  */
# LANGUAGE: R     R                                            */
#                                                              */
#  SUPPORT: Bob Derr                                           */
#     MISC:                                                    */
#                                                              */
#***************************************************************/

#****************************************************************
# Binary Logistic Regression
#***************************************************************/

# The data consists of 100 observations on a dichotomous response
# variable y, a character variable C, and 10 continuous variables
# x1--x10.  A main effects binary logistic regression model is fit to
# these data, and the resulting model is stored.  The stored model is
# then used to produce predicted probabilities and other
# observationwise statistics for a new data table.

m <- cas.read.csv(s, "getStarted.csv", casOut=list(name="getStarted"))

m <- cas.builtins.loadActionSet(s, actionset='regression')
m <- cas.regression.logistic(s,
   table='getStarted',
   class='C',
   model=list(depvar='y',
              effects=list('C', 'x2', 'x8')),
   store=list(name='myModel', replace=TRUE),
   output=list(casOut=list(name='out1',replace=TRUE),
               pred='pred', resChi='reschi', into='into',
               copyVars=list('y', 'id'))
)

print(m$OutputCasTables)

m <- cas.regression.logisticScore(s,
   restore='myModel',
   table='getStarted',
   fitData=TRUE,
   casOut=list(name='out2', replace=TRUE),
   copyVars=list('y', 'id'),
   pred='pred', resChi='reschi', into='into'
)

cas.table.fetch(s, table='out1', orderby='id', to='5')
cas.table.fetch(s, table='out2', orderby='id', to='5')

