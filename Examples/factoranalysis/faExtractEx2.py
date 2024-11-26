"""
S A S   S A M P L E   L I B R A R Y

    NAME: faExtractEx2
   TITLE: Example 4 for the factorAnalysis action set
 PRODUCT: VIYA Statistics
    KEYS: faExtract
   PROCS: factorAnalysis action set, faExtract action
    DATA:
    MISC:

Uses the socioeconomics data set from the PROC FACTOR documentation.
"""


s.loadactionset(actionset='factorAnalysis')

s.factoranalysis.faextract(
    method=dict(heywood='bound', name='prinit'),
    nFactors=[2],
    table='socioeconomics')

s.factoranalysis.faextract(
    method=dict(heywood='bound', name='ml'),
    nFactors=[2],
    table='socioeconomics')

