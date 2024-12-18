--[[
S A S   S A M P L E   L I B R A R Y

    NAME: faExtractEx3
   TITLE: Example 4 for the factorAnalysis action set
 PRODUCT: VIYA Statistics
    KEYS: faExtract
   PROCS: factorAnalysis action set, faExtract action
    DATA:
    MISC:

Uses the jobratings data set from the PROC FACTOR documentation.
--]]


s:loadactionset{actionset="factorAnalysis"}

s:factorAnalysis_faExtract{
table='jobratings',
nFactors={2},
method={name='ml'},
rotate={type='quartimin'},
reorder=true,
fuzz=0.4
}

s:factorAnalysis_faExtract{
table='jobratings',
nFactors={3},
method={name='ml'},
rotate={type='quartimin'},
reorder=true,
fuzz=0.4
}

