if(FALSE){
S A S   S A M P L E   L I B R A R Y

    NAME: sltrainex1
   TITLE: Example 1 for slTrain action
 PRODUCT: VIYA Statistics
    KEYS: SUPERLEARNER
   PROCS: superLearner action set, slTrain action
    DATA:
    MISC:
}


m <- cas.builtins.loadActionSet(s, actionset='superLearner')

cas.superLearner.slTrain(s,
    inputs=c('nAtBat', 'nHits', 'nHome', 'nRuns', 'nRBI', 'nBB', 'yrMajor',
             'crAtBat', 'crHits', 'crHome', 'league', 'division', 'crRuns',
             'crRbi', 'crBB', 'nOuts', 'nAssts', 'nError'),
    k='6',
    library=list(list(modelType='GLM', name='glm'),
                 list(modelType='DTREE', name='dtree'),
                 list(modelType='BARTGAUSS',
                      name='bart',
                      trainOptions=list(inputs=c('nAtBat', 'nHits', 'nHome',
      'nRuns', 'nRBI', 'nBB', 'yrMajor', 'crAtBat', 'crHits', 'crHome',
      'league', 'division', 'crRuns', 'crRbi', 'crBB', 'nOuts', 'nAssts',
      'nError'),
                                        nMC='100',
                                        nTree='10',
                                        nominals=c('league', 'division'),
                                        table='baseball',
                                        target='logSalary'))),
    nominals=c('league', 'division'),
    seed='846203',
    store=list(name='modelFit', replace='true'),
    table='baseball',
    target='logSalary')

m <- cas.read.csv(s, "Baseball.csv", casOut=list(name="Baseball"))

cas.builtins.loadactionset(s, actionset='superLearner')
cas.superLearner.slScore(s,
   table='baseball',
   restore='modelFit',
   casOut=list(name='scoredData1', replace='true'))

cas.table.fetch(s, table='scoredData1', to='10')

cas.superLearner.slScore(s,
   table='baseball',
   restore='modelFit',
   margins=list(list(at=list(list(value='1', var='nHome')),
                     name='Scenario1'),
           list(at=list(list(value='10', var='nHome'),
                        list(value='60', var='nRuns')),
                     name='Scenario2')],
   marginPredOut=true,
   casOut=list(name='scoredData2', replace='true'))

cas.table.fetch(s, table='scoredData2', to='10')

