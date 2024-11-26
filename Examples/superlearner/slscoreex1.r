 if(FALSE){
 S A S   S A M P L E   L I B R A R Y

     NAME: slscoreex1
     TITLE: Example 1 for slScore action
     PRODUCT: VIYA Statistics
     KEYS: SUPERLEARNER
     PROCS: superLearner action set, slScore action
     DATA:
     MISC:

 Used the modelFit store created in sltrainex1 to score new
 data.
 }

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

