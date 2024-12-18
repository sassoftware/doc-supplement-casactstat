"""
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
"""


s.loadactionset(actionset='regression')

s.regression.logistic(
    class_=['Sex', 'Race', 'Education', 'Exercise', 'Activity'],
    model=dict(depvar=[dict(name='Quit', options=dict(event='1'))],
               effects=['Sex', 'Race', 'Education', 'Exercise', 'Activity',
                        'Age', 'YearsSmoke', 'PerDay']),
    output=dict(casout=dict(name='swDREstData', replace='True'),
                copyvars='All',
                pred='pTrt'),
    table='SmokingWeight')

s.datastep.runcode(
    code='''
   data swDREstData;
      set swDREstData;
      pCnt = 1 - pTrt;
   run;
   ''')

s.loadactionset(actionset='bart')

s.bart.bartgauss(
    inputs=['Sex', 'Race', 'Education', 'Exercise', 'Quit', 'Activity', 'Age',
            'YearsSmoke', 'PerDay'],
    nMC='200',
    nTree='100',
    nominals=['Sex', 'Race', 'Education', 'Exercise', 'Activity', 'Quit'],
    seed='2156',
    store=dict(name='bartOutMod', replace='True'),
    table='swDREstData',
    target='Change')

s.loadactionset(actionset='causalAnalysis')

s.causalanalysis.caeffect(
    difference=[dict(evtLev='1')],
    method='aipw',
    outcomeModel=dict(predName='P_Change', store='bartOutMod'),
    outcomeVariable='Change',
    pom=[dict(trtLev='1', trtProb='pTrt'), dict(trtLev='0', trtProb='pCnt')],
    table='swDREstData',
    treatVar='Quit')

s.loadactionset(actionset='causalAnalysis')

s.causalanalysis.caeffect(
    difference=[dict(evtLev='1')],
    method='tmle',
    outcomeModel=dict(predName='P_Change', store='bartOutMod'),
    outcomeVariable='Change',
    pom=[dict(trtLev='1', trtProb='pTrt'), dict(trtLev='0', trtProb='pCnt')],
    table='swDREstData',
    treatVar='Quit')

