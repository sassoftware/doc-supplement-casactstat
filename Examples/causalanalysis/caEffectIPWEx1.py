"""
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
"""


s.loadactionset(actionset='regression')

s.regression.logistic(
    class_=['Sex', 'Race', 'Education', 'Exercise', 'Activity'],
    model=dict(depvar='Quit',
               effects=['Sex', 'Race', 'Education', 'Exercise', 'Activity',
                        'Age', 'YearsSmoke', 'PerDay']),
    store=dict(name='logTrtModel', replace='true'),
    table='SmokingWeight')

s.loadactionset(actionset='aStore')

s.astore.score(
    copyVars=['Quit', 'Change'],
    out=dict(name='logScored'),
    rstore='logTrtModel',
    table='SmokingWeight')

s.loadactionset(actionset='causalAnalysis')

s.causalanalysis.caeffect(
    difference=[dict(refLev='0')],
    inference='TRUE',
    outcomeVar='Change',
    pom=[dict(trtLev='1', trtProb='P_Quit1'),
         dict(trtLev='0', trtProb='P_Quit0')],
    table='logScored',
    treatVar='Quit')

s.causalanalysis.caeffect(
    difference=[dict(refLev='0')],
    outcomeVar='Change',
    pom=[dict(trtLev='1', trtProb='P_Quit1'),
         dict(trtLev='0', trtProb='P_Quit0')],
    table='logScored',
    treatVar=dict(condEvent='1', name='Quit'))

