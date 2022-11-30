--[[
S A S   S A M P L E   L I B R A R Y

    NAME: bartscoreex1
   TITLE: Example 1 for bartScoreMargin action
 PRODUCT: VIYA Statistics
    KEYS: BART
   PROCS: bart action set, bartScoreMargin action
    DATA:
     MISC:

Uses the modelFit store created in bartgaussex1 and testData data
table created in bartscoreex1 to compute predictive margins.
--]]

s:bart_bartScoreMargin{
   table ='testData',
   restore = 'modelFit',
   marginInfo =true,
   margins= {
     { name='Scenario1', at={{var='x2', value=0.25}}},
     { name='Scenario2', at={{var='x2', value=0.25}, {var='x3',
     value=0.5}} },
     { name='x1Ref',     at={{var='x1', value=0.25}} },
     { name='x1Evt1',    at={{var='x1', value=0.5}} },
     { name='x1Evt2',    at={{var='x1', value=0.75}} }
   },
   differences = {
     { label='x1:0.5 - 0.25',  refMargin='x1Ref', evtMargin='x1Evt1'},
     { label='x1:0.75 - 0.25', refMargin='x1Ref', evtMargin='x1Evt2'}
   }
}

