#***************************************************************************/
#             S A S   S A M P L E   L I B R A R Y                          */
#                                                                          */
#         NAME: logiex2                                                    */
#        TITLE: Example 2 for logistic action -- Modeling Binomial Data    */
#                                                                          */
#      PRODUCT: VIYA Statistics                                            */
#         KEYS: Logistic regression analysis,                              */
#               Binomial response data                                     */
#        PROCS: regression action set,logistic action                      */
#         DATA: Cox and Snell (1989, pp 10-11)                             */
#      SUPPORT: Bob Derr                                                   */
#         MISC:                                                            */
#                                                                          */
#***************************************************************************/

# The data, taken from Cox and Snell (1989, pp 10-11), consists of
# the number, r, of ingots not ready for rolling, out of n tested,
# for a number of combinations of heating time and soaking time.
# A binomial logistic regression is performed using events/trials
# syntax to fit a binary logit model to the grouped data.

# m <- cas.read.csv(s, "Ingots.csv", casOut=list(name="Ingots"))

cas.dataStep.runCode(s,
   code='
   data mycas.Ingots;
      input Heat Soak r n @@;
      a = n - r;
      Obsnum = _n_;
      datalines;
   7 1.0 0 10  14 1.0 0 31  27 1.0 1 56  51 1.0 3 13
   7 1.7 0 17  14 1.7 0 43  27 1.7 4 44  51 1.7 0  1
   7 2.2 0  7  14 2.2 2 33  27 2.2 0 21  51 2.2 0  1
   7 2.8 0 12  14 2.8 0 31  27 2.8 1 22  51 4.0 0  1
   7 4.0 0  9  14 4.0 0 19  27 4.0 1 16
   ;
   run;
   ',
    single='no')

m <- cas.builtins.loadActionSet(s, actionset='regression')

cas.regression.logistic(s,
    association='true',
    ctable=list(casOut=list(name='Roc', replace='true'),
                fpf='FPF',
                nocounts='true',
                tpf='TPF'),
    model=list(depVars=list(list(name='r')),
               effects=list(list(vars=c('Heat', 'Soak')),
                            list(interaction='CROSS', vars=c('Heat', 'Soak'))),
               trial='n'),
    output=list(casOut=list(name='Out', replace='true'),
                copyVars=c('Heat', 'Soak'),
                pred='Pred',
                xBeta='_XBETA_'),
    table='Ingots')

cas.table.fetch(s,
    format='true',
    index='false',
    table=list(name='Out', where='14 = Heat and 1.7 = Soak'))

cas.regression.logistic(s,
    model=list(depVars=list(list(name='r'), list(name='a')),
               effects=list(list(vars=c('Heat', 'Soak')),
                            list(interaction='CROSS', vars=c('Heat', 'Soak')))),
    table='Ingots')

cas.dataStep.runCode(s,
    code='
   data Ingots_binary;
      set Ingots;
      do i=1 to n;
        if i <= r then y=1; else y = 0;
        output;
      end;
   run;
   ',
    single='no')

cas.regression.logistic(s,
    model=list(depVars=list(list(name='y', options=list(event='1'))),
               effects=list(list(vars=c('Heat', 'Soak')),
                            list(interaction='CROSS', vars=c('Heat', 'Soak')))),
    table=list(name='Ingots_binary'))

