 """
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
 """

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

