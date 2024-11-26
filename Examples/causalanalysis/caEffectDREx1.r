if(FALSE){
S A S   S A M P L E   L I B R A R Y

    NAME: caEffectDREx1
   TITLE: Example 1 for doubly robust estimation with caEffect action
 PRODUCT: VIYA Statistics
    KEYS: caEffect
   PROCS: causalAnalysis action set, caEffect action
    DATA:
    MISC:

Uses the SmokingWeight data set from the PROC CAUSALTRT
documentation. Fits a propensity score model by using
regression.logistic and an outcome model by using
bart.bartGauss.
}


m <- cas.builtins.loadActionSet(s, actionset='regression')

cas.regression.logistic(s,
    class=c('Sex', 'Race', 'Education', 'Exercise', 'Activity'),
    model=list(depvar=list(list(name='Quit', options=list(event='1'))),
               effects=c('Sex', 'Race', 'Education', 'Exercise', 'Activity',
                         'Age', 'YearsSmoke', 'PerDay')),
    output=list(casout=list(name='swDREstData', replace='True'),
                copyvars='All',
                pred='pTrt'),
    table='SmokingWeight')

cas.dataStep.runCode(s,
    code='
   data swDREstData;
      set swDREstData;
      pCnt = 1 - pTrt;
   run;
   ')

m <- cas.builtins.loadActionSet(s, actionset='bart')

cas.bart.bartGauss(s,
    inputs=c('Sex', 'Race', 'Education', 'Exercise', 'Quit', 'Activity', 'Age',
             'YearsSmoke', 'PerDay'),
    nMC='200',
    nTree='100',
    nominals=c('Sex', 'Race', 'Education', 'Exercise', 'Activity', 'Quit'),
    seed='2156',
    store=list(name='bartOutMod', replace='True'),
    table='swDREstData',
    target='Change')

m <- cas.builtins.loadActionSet(s, actionset='causalAnalysis')

cas.causalAnalysis.caEffect(s,
    difference=list(list(evtLev='1')),
    method='aipw',
    outcomeModel=list(predName='P_Change', store='bartOutMod'),
    outcomeVariable='Change',
    pom=list(list(trtLev='1', trtProb='pTrt'),
             list(trtLev='0', trtProb='pCnt')),
    table='swDREstData',
    treatVar='Quit')

m <- cas.builtins.loadActionSet(s, actionset='causalAnalysis')

cas.causalAnalysis.caEffect(s,
    difference=list(list(evtLev='1')),
    method='tmle',
    outcomeModel=list(predName='P_Change', store='bartOutMod'),
    outcomeVariable='Change',
    pom=list(list(trtLev='1', trtProb='pTrt'),
             list(trtLev='0', trtProb='pCnt')),
    table='swDREstData',
    treatVar='Quit')

