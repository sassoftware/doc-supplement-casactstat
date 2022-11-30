
S A S   S A M P L E   L I B R A R Y

    NAME: caEffectIPWEx1
   TITLE: Example 1 for RegAdj estimation with caEffect action
 PRODUCT: VIYA Statistics
    KEYS: caEffect
   PROCS: causalAnalysis action set, caEffect action
    DATA:
     MISC:

Uses the birthwgt data set from the PROC CAUSALMED
documentation. Fits an outcome model by using
decisionTree.gbtreeTrain action.



m <- cas.builtins.loadActionSet(s, actionset='decisionTree')

cas.decisionTree.gbtreeTrain(s,
    inputs=c('Smoking', 'AgeGroup', 'Married', 'Drinking', 'SomeCollege'),
    nTrees='100',
    nominals=c('Smoking', 'AgeGroup', 'Married', 'Drinking', 'SomeCollege',
               'Death'),
    savestate=list(name='gbOutMod', replace='TRUE'),
    table='birthwgt',
    target='Death')

m <- cas.builtins.loadActionSet(s, actionset='causalAnalysis')

cas.causalAnalysis.caEffect(s,
    outcomeModel=list(predName='P_DeathYes', restore='gbOutMod'),
    outcomeVar=list(event='Yes', type='Categorical'),
    pom=list(list(trtLev='Yes'), list(trtLev='No')),
    table='birthwgt',
    treatVar='Smoking')

m <- cas.builtins.loadActionSet(s, actionset='table')

cas.table.alterTable(s,
    columns=list(list(name='Smoking', rename='tempSmoking')),
    name='birthwgt')

m <- cas.builtins.loadActionSet(s, actionset='aStore')

cas.aStore.score(s,
    copyVars=c('tempSmoking', 'AgeGroup', 'Married', 'Drinking', 'SomeCollege'),
    out=list(name='gbPredData', replace='True'),
    rstore=list(name='gbOutMod'),
    table=list(computedVars=list(list(name='Smoking')),
               computedVarsProgram='Smoking=\'Yes\'',
               name='birthwgt'))

cas.table.alterTable(s,
    columns=list(list(name='P_DeathYes', rename='SmokingPred')),
    name='gbPredData')

cas.aStore.score(s,
    copyVars=c('tempSmoking', 'SmokingPred'),
    out=list(name='gbPredData', replace='True'),
    rstore=list(name='gbOutMod'),
    table=list(computedVars=list(list(name='Smoking')),
               computedVarsProgram='Smoking=\'No\'',
               name='gbPredData'))

cas.table.alterTable(s,
    columns=list(list(name='P_DeathYes', rename='NoSmokingPred'),
                 list(name='tempSmoking', rename='Smoking')),
    name='gbPredData')

cas.causalAnalysis.caEffect(s,
    outcomeVar=list(event='Yes', type='Categorical'),
    pom=list(list(predOut='SmokingPred', trtLev='Yes'),
             list(predOut='NoSmokingPred', trtLev='No')),
    table='gbPredData',
    treatVar='Smoking')

