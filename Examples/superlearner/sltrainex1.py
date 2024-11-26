"""
S A S   S A M P L E   L I B R A R Y

    NAME: sltrainex1
   TITLE: Example 1 for slTrain action
 PRODUCT: VIYA Statistics
    KEYS: SUPERLEARNER
   PROCS: superLearner action set, slTrain action
    DATA:
    MISC:
"""


s.loadactionset(actionset='superLearner')

s.superlearner.sltrain(
    inputs=['nAtBat', 'nHits', 'nHome', 'nRuns', 'nRBI', 'nBB', 'yrMajor',
            'crAtBat', 'crHits', 'crHome', 'league', 'division', 'crRuns',
            'crRbi', 'crBB', 'nOuts', 'nAssts', 'nError'],
    k='6',
    library=[dict(modelType='GLM', name='glm'),
             dict(modelType='DTREE', name='dtree'),
             dict(modelType='BARTGAUSS',
                  name='bart',
                  trainOptions=dict(inputs=['nAtBat', 'nHits', 'nHome', 'nRuns',
      'nRBI', 'nBB', 'yrMajor', 'crAtBat', 'crHits', 'crHome', 'league',
      'division', 'crRuns', 'crRbi', 'crBB', 'nOuts', 'nAssts', 'nError'],
                                    nMC='100',
                                    nTree='10',
                                    nominals=['league', 'division'],
                                    table='baseball',
                                    target='logSalary'))],
    nominals=['league', 'division'],
    seed='846203',
    store=dict(name='modelFit', replace='true'),
    table='baseball',
    target='logSalary')

s.upload_file('Baseball.csv')

s.loadactionset(actionset='superLearner')
s.superLearner.slScore(
   table='baseball',
   restore='modelFit',
   casOut=dict(name='scoredData1', replace='true'))

a=s.fetch(table={'name':'scoredData1'}, to='10')
print(a)

s.superLearner.slScore(
   table='baseball',
   restore='modelFit',
   margins=[dict(at=[dict(value='1', var='nHome')],
                 name='Scenario1'),
            dict(at=[dict(value='10', var='nHome'),
                     dict(value='60', var='nRuns')],
                 name='Scenario2')],
   marginPredOut=true,
   casOut=dict(name='scoredData2', replace='true'))

b=s.fetch(table={'name':'scoredData2'}, to='10')
print(b)

