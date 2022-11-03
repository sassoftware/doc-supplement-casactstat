#***************************************************************/
#          S A S   S A M P L E   L I B R A R Y                 */
#                                                              */
#     NAME: logorgs1                                           */
#    TITLE: Example for logisticOddsRatio Action               */
#     DESC: Binary Logistic Regression                         */
#  PRODUCT: VIYA Statistics                                    */
#   SYSTEM: ALL                                                */
#     KEYS: Logistic regression analysis,                      */
#           Binary response data                               */
#    PROCS: regression action set; logisticOddsRatio action    */
#    DATA:  getStarted data from Example 1 of logistic action  */
# LANGUAGE: R                                                  */
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
# x1--x10.  A main-effects binary logistic regression model is fit to
# these data.  A table of odds ratios is displayed.

m <- cas.read.csv(s, "getStarted.csv", casOut=list(name="getStarted"))

m <- cas.builtins.loadActionSet(s, actionset='regression')
m <- cas.regression.logistic(s,
   table='getStarted',
   class='C',
   model=list(depvar='y',
              effects=list('C', 'x2', 'x8')),
   store=list(name='myModel',replace=TRUE)
)

m <- cas.regression.logisticOddsRatio(s,
   oddsratios=c('C', 'x2'),
   restore='myModel')

print(m$OddsRatios)

m <- cas.builtins.loadActionSet(s, actionset='regression')
m <- cas.regression.logistic(s,
   table='getStarted',
   class='C',
   model=list(depvar='y',
              effects=list(list(vars=list('C', 'x2', 'x8'),interaction='BAR'))),
   store=list(name='myModel2',replace=TRUE)
)
m <- cas.regression.logisticOddsRatio(s,
   restore='myModel2',
   oddsratios=c('C', 'x2'),
)

m <- cas.regression.logisticOddsRatio(s,
   oddsratios=list(list(at=list(list(level=c('A', 'B'),var='C'),
                                list(values='1', var='x8')),unit=c(5, 10),var='x2')),
   restore='myModel2')

m <- cas.regression.logisticOddsRatio(s,
   at=list(list(level=c('A', 'B'),var='C'),list(values='1', var='x8')),
   oddsratios=c('x2'),
   restore='myModel2',
   unit=list(list(value=c(5, 10),var='x2')))

