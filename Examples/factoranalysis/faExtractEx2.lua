--[[
S A S   S A M P L E   L I B R A R Y

    NAME: faExtractEx2
   TITLE: Example 4 for the factorAnalysis action set
 PRODUCT: VIYA Statistics
    KEYS: faExtract
   PROCS: factorAnalysis action set, faExtract action
    DATA:
    MISC:

Uses the socioeconomics data set from the PROC FACTOR documentation.
--]]


s:loadactionset{actionset="factorAnalysis"}

s:factorAnalysis_faExtract{
table='socioeconomics',
nFactors={2},
method={name='prinit', heywood='bound'},
}

s:factorAnalysis_faExtract{
table='socioeconomics',
nFactors={2},
method={name='ml', heywood='bound'},
}

