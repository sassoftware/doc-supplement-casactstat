
S A S   S A M P L E   L I B R A R Y

    NAME: caEffectDREx1
   TITLE: Example 1 for doubly robust estimation with caEffect action
 PRODUCT: VIYA Statistics
    KEYS: caEffect
   PROCS: causalAnalysis action set, caEffect action
    DATA:
 SUPPORT: Michael Lamm
    MISC:

Uses the SmokingWeight data set from the PROC CAUSALTRT
documentation. Fits a propensity score model by using
regression.logistic and an outcome model by using
bart.bartGauss.



s:loadactionset{actionset="regression"}

s:regression_logistic{
   table='SmokingWeight',
   class={'Sex', 'Race', 'Education', 'Exercise', 'Activity'},
   model={depvar={{name='Quit',options={event='1'}}},
          effects={'Sex', 'Race', 'Education', 'Exercise',
                    'Activity', 'Age', 'YearsSmoke', 'PerDay'}},
   output = {casout={name='swDREstData', replace=True},
             copyvars='All', pred='pTrt'}
   }

s:dataStep_runCode{code=[[
data swDREstData;
   set swDREstData;
   pCnt = 1 - pTrt;
run;
]] }

s:loadactionset{actionset="bart"}

s:bart_bartGauss{
   table = 'swDREstData',
   target='Change',
   inputs={'Sex', 'Race', 'Education', 'Exercise',
           'Quit', 'Activity', 'Age', 'YearsSmoke', 'PerDay'},
   nominals={'Sex', 'Race', 'Education', 'Exercise', 'Activity',
   'Quit'},
   nMC=200,
   nTree=100,
   seed=2156,
   store={name='bartOutMod', replace=True}
}

s:loadactionset{actionset="causalAnalysis"}

s:causalAnalysis_caEffect{
   table = 'swDREstData',
   outcomeVariable='Change',
   treatVar='Quit',
   outcomeModel={store='bartOutMod', predName='P_Change'},
   method ='aipw',
   pom = {{trtLev ='1', trtProb ='pTrt'},
              {trtLev ='0', trtProb ='pCnt'}},
   difference ={{evtLev='1'}}
}

s:loadactionset{actionset="causalAnalysis"}

s:causalAnalysis_caEffect{
   table = 'swDREstData',
   outcomeVariable='Change',
   treatVar='Quit',
   outcomeModel={store='bartOutMod', predName='P_Change'},
   method ='tmle',
   pom = {{trtLev ='1', trtProb ='pTrt'},
              {trtLev ='0', trtProb ='pCnt'}},
   difference ={{evtLev='1'}}
}

