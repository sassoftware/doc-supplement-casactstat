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

# s.upload_file('Ingots.csv')
s.datastep.runcode(
   code='''
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
   ''',
    single='no')

s.loadactionset(actionset='regression')

s.regression.logistic(
    association='true',
    ctable=dict(casOut=dict(name='Roc', replace='true'),
                fpf='FPF',
                nocounts='true',
                tpf='TPF'),
    model=dict(depVars=[dict(name='r')],
               effects=[dict(vars=['Heat', 'Soak']),
                        dict(interaction='CROSS', vars=['Heat', 'Soak'])],
               trial='n'),
    output=dict(casOut=dict(name='Out', replace='true'),
                copyVars=['Heat', 'Soak'],
                pred='Pred',
                xBeta='_XBETA_'),
    table='Ingots')

s.table.fetch(
    format='true',
    index='false',
    table=dict(name='Out', where='14 = Heat and 1.7 = Soak'))

s.regression.logistic(
    model=dict(depVars=[dict(name='r'), dict(name='a')],
               effects=[dict(vars=['Heat', 'Soak']),
                        dict(interaction='CROSS', vars=['Heat', 'Soak'])]),
    table='Ingots')

s.datastep.runcode(
    code='''
   data Ingots_binary;
      set Ingots;
      do i=1 to n;
        if i <= r then y=1; else y = 0;
        output;
      end;
   run;
   ''',
    single='no')

s.regression.logistic(
    model=dict(depVars=[dict(name='y', options=dict(event='1'))],
               effects=[dict(vars=['Heat', 'Soak']),
                        dict(interaction='CROSS', vars=['Heat', 'Soak'])]),
    table=dict(name='Ingots_binary'))

