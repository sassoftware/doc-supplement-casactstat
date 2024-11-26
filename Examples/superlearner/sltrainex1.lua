--[[
S A S   S A M P L E   L I B R A R Y

    NAME: sltrainex1
   TITLE: Example 1 for slTrain action
 PRODUCT: VIYA Statistics
    KEYS: SUPERLEARNER
   PROCS: superLearner action set, slTrain action
    DATA:
    MISC:
--]]


s:loadactionset{actionset="superLearner"}

s:superLearner_slTrain{
   table='baseball',
   target='logSalary',
   nominals={'league','division'},
   inputs={'nAtBat', 'nHits', 'nHome', 'nRuns', 'nRBI', 'nBB',
   'yrMajor', 'crAtBat', 'crHits', 'crHome', 'league', 'division',
   'crRuns', 'crRbi', 'crBB', 'nOuts', 'nAssts', 'nError'},
   library={
      {name='glm', modelType='GLM'},
      {name='dtree', modelType='DTREE'},
      {name='bart', modelType='BARTGAUSS',
       trainOptions={table='baseball',
                     target='logSalary',
                     nominals={'league','division'},
                     inputs={'nAtBat', 'nHits', 'nHome', 'nRuns', 'nRBI', 'nBB',
                             'yrMajor', 'crAtBat', 'crHits', 'crHome', 'league',
                             'division', 'crRuns', 'crRbi', 'crBB', 'nOuts',
                             'nAssts', 'nError'},
                     nTree=10,
                     nMC=100
                     }
      }
   },
   k=6,
   seed=846203,
   store={name='modelFit', replace='true'}
   }

s:loadtable{casLib="casuser", path="Baseball.csv"}

s:loadactionset{actionset='superLearner'}
s:superLearner_slScore{
   table='baseball',
   restore='modelFit',
   casOut={name='scoredData1', replace=true}
   }

a=s:fetch{table={name='scoredData1'}, to=10}
print(a)

s:superLearner_slScore{
   table='baseball',
   restore='modelFit',
   margins={{at={{value='1', var='nHome'}}, name='Scenario1'},
            {at={{value='10', var='nHome'}, {value='60', var='nRuns'}},
               name='Scenario2'}},
   marginPredOut=true,
   casOut={name='scoredData2', replace=true}
   }

b=s:fetch{table={name='scoredData2'}, to=10}
print(b)

