--[[
S A S   S A M P L E   L I B R A R Y

    NAME: faNFactorsEx1
   TITLE: Example 1 for the faNFactors action
 PRODUCT: VIYA Statistics
    KEYS: faNFactors
   PROCS: factorAnalysis action set, faNFactors action
    DATA:
    MISC:

Uses the simulated testdata data set from the Principal
Component Analysis Action Set documentation.
--]]


s:loadactionset{actionset="factorAnalysis"}

s:factorAnalysis_faNFactors{
   table='testdata',
   criteria={
      {type='eigenvalue'},
      {type='proportion', threshold={0.9}}
   }
   }

s:loadactionset{actionset="factorAnalysis"}

s:factorAnalysis_faNFactors{
   table='testdata',
   criteria={
      {type='proportion', threshold={0.90,0.95,0.99}},
   },
   priors='one'
   }

