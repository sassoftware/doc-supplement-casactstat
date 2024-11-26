--[[
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
--]]


s:loadactionset{actionset="regression"}

s:regression_logistic{
   table='SmokingWeight',
   class={'Sex', 'Race', 'Education', 'Exercise', 'Activity'},
   model={depvar='Quit',
          effects={'Sex', 'Race', 'Education', 'Exercise',
                    'Activity', 'Age', 'YearsSmoke', 'PerDay'}},
   store={name='logTrtModel', replace=true}
   }

s:loadactionset{actionset="aStore"}

s:aStore_score{
   table='SmokingWeight',
   rstore='logTrtModel',
   out={name='logScored'},
   copyVars={'Quit', 'Change'}
   }

s:loadactionset{actionset="causalAnalysis"}

s:causalAnalysis_caEffect{
   table='logScored',
   treatVar='Quit',
   outcomeVar='Change',
   inference=TRUE,
   pom={{trtLev='1', trtProb='P_Quit1'},
            {trtLev='0', trtProb='P_Quit0'}},
   difference={{refLev='0'}}
   }

s:causalAnalysis_caEffect{
   table='logScored',
   treatVar={name='Quit', condEvent='1'},
   outcomeVar='Change',
   pom={{trtLev='1', trtProb='P_Quit1'},
            {trtLev='0', trtProb='P_Quit0'}},
   difference={{refLev='0'}}
   }

