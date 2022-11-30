
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



s.loadactionset(actionset='decisionTree')

s.decisiontree.gbtreetrain(
    inputs=['Smoking', 'AgeGroup', 'Married', 'Drinking', 'SomeCollege'],
    nTrees='100',
    nominals=['Smoking', 'AgeGroup', 'Married', 'Drinking', 'SomeCollege',
              'Death'],
    savestate=dict(name='gbOutMod', replace='TRUE'),
    table='birthwgt',
    target='Death')

s.loadactionset(actionset='causalAnalysis')

s.causalanalysis.caeffect(
    outcomeModel=dict(predName='P_DeathYes', restore='gbOutMod'),
    outcomeVar=dict(event='Yes', type='Categorical'),
    pom=[dict(trtLev='Yes'), dict(trtLev='No')],
    table='birthwgt',
    treatVar='Smoking')

s.loadactionset(actionset='table')

s.table.altertable(
    columns=[dict(name='Smoking', rename='tempSmoking')],
    name='birthwgt')

s.loadactionset(actionset='aStore')

s.astore.score(
    copyVars=['tempSmoking', 'AgeGroup', 'Married', 'Drinking', 'SomeCollege'],
    out=dict(name='gbPredData', replace='True'),
    rstore=dict(name='gbOutMod'),
    table=dict(computedVars=[dict(name='Smoking')],
               computedVarsProgram='Smoking=\'Yes\'',
               name='birthwgt'))

s.table.altertable(
    columns=[dict(name='P_DeathYes', rename='SmokingPred')],
    name='gbPredData')

s.astore.score(
    copyVars=['tempSmoking', 'SmokingPred'],
    out=dict(name='gbPredData', replace='True'),
    rstore=dict(name='gbOutMod'),
    table=dict(computedVars=[dict(name='Smoking')],
               computedVarsProgram='Smoking=\'No\'',
               name='gbPredData'))

s.table.altertable(
    columns=[dict(name='P_DeathYes', rename='NoSmokingPred'),
             dict(name='tempSmoking', rename='Smoking')],
    name='gbPredData')

s.causalanalysis.caeffect(
    outcomeVar=dict(event='Yes', type='Categorical'),
    pom=[dict(predOut='SmokingPred', trtLev='Yes'),
         dict(predOut='NoSmokingPred', trtLev='No')],
    table='gbPredData',
    treatVar='Smoking')

