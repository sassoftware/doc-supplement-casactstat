"""
S A S   S A M P L E   L I B R A R Y

    NAME: faExtractEx1
   TITLE: Example 3 for the factorAnalysis action set
 PRODUCT: VIYA Statistics
    KEYS: faExtract
   PROCS: factorAnalysis action set, faExtract action
    DATA:
    MISC:

Uses the socioeconomics data set from the PROC FACTOR documentation.
"""


s.loadactionset(actionset='factorAnalysis')

s.factoranalysis.faextract(
    method=dict(name='principal'),
    nFactors=[2],
    reorder='true',
    rotate=dict(type='promax'),
    table='socioeconomics')

