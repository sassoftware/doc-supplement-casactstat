--[[
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
--]]


s:loadactionset{actionset="decisionTree"}

s:decisionTree_gbtreeTrain{
   table='birthwgt',
   target='Death',
   inputs={'Smoking', 'AgeGroup', 'Married', 'Drinking',
           'SomeCollege'},
   nominals={'Smoking', 'AgeGroup', 'Married', 'Drinking',
           'SomeCollege', 'Death'},
   nTrees=100,
   savestate={name='gbOutMod', replace=TRUE}
   }

s:loadactionset{actionset="causalAnalysis"}

s:causalAnalysis_caEffect{
   table='birthwgt',
   treatVar='Smoking',
   outcomeVar={type=Categorical, event='Yes'},
   outcomeModel={restore='gbOutMod', predName='P_DeathYes'},
   pom = {{trtLev ="Yes"},
              {trtLev ="No"}
             }
   }

s:loadactionset{actionset="table"}

s:table_alterTable{
   name='birthwgt',
   columns={{name='Smoking', rename='tempSmoking'}}
   }

s:loadactionset{actionset="aStore"}

s:aStore_score{
   table={name='birthwgt',
          computedVars={{name='Smoking'}},
          computedVarsProgram="Smoking='Yes'"
          },
   rstore={name='gbOutMod'},
   out ={name='gbPredData', replace=True},
   copyVars={'tempSmoking', 'AgeGroup', 'Married', 'Drinking',
             'SomeCollege'}
}

s:table_alterTable{
   name='gbPredData',
   columns={{name='P_DeathYes', rename='SmokingPred'}}
  }

s:aStore_score{
   table={name='gbPredData',
          computedVars={{name='Smoking'}},
          computedVarsProgram="Smoking='No'"
          },
   rstore={name='gbOutMod'},
   out ={name='gbPredData', replace=True},
   copyVars={'tempSmoking', 'SmokingPred'}
}

s:table_alterTable{
   name='gbPredData',
   columns={{name='P_DeathYes', rename='NoSmokingPred'},
             {name='tempSmoking', rename='Smoking'}}
  }

s:causalAnalysis_caEffect{
   table='gbPredData',
   treatVar='Smoking',
   outcomeVar={type=Categorical, event='Yes'},
   pom = {{trtLev ='Yes', predOut='SmokingPred'},
              {trtLev ='No' , predOut='NoSmokingPred'}}
   }

