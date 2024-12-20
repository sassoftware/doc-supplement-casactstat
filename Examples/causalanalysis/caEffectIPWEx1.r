if(FALSE){
S A S   S A M P L E   L I B R A R Y

    NAME: caEffectIPWEx1
   TITLE: Example 1 for IPW estimation with caEffect action
 PRODUCT: VIYA Statistics
    KEYS: caEffect
   PROCS: causalAnalysis action set, caEffect action
    DATA:
    MISC:

Uses the SmokingWeight data set from the PROC CAUSALTRT
documentation. Fits a propensity score model by using
regression.logistic.
}


m <- cas.builtins.loadActionSet(s, actionset='regression')

cas.regression.logistic(s,
    class=c('Sex', 'Race', 'Education', 'Exercise', 'Activity'),
    model=list(depvar='Quit',
               effects=c('Sex', 'Race', 'Education', 'Exercise', 'Activity',
                         'Age', 'YearsSmoke', 'PerDay')),
    store=list(name='logTrtModel', replace='true'),
    table='SmokingWeight')

m <- cas.builtins.loadActionSet(s, actionset='aStore')

cas.aStore.score(s,
    copyVars=c('Quit', 'Change'),
    out=list(name='logScored'),
    rstore='logTrtModel',
    table='SmokingWeight')

m <- cas.builtins.loadActionSet(s, actionset='causalAnalysis')

cas.causalAnalysis.caEffect(s,
    difference=list(list(refLev='0')),
    inference='TRUE',
    outcomeVar='Change',
    pom=list(list(trtLev='1', trtProb='P_Quit1'),
             list(trtLev='0', trtProb='P_Quit0')),
    table='logScored',
    treatVar='Quit')

cas.causalAnalysis.caEffect(s,
    difference=list(list(refLev='0')),
    outcomeVar='Change',
    pom=list(list(trtLev='1', trtProb='P_Quit1'),
             list(trtLev='0', trtProb='P_Quit0')),
    table='logScored',
    treatVar=list(condEvent='1', name='Quit'))

