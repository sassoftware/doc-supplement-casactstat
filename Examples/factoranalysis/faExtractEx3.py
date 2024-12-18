"""
S A S   S A M P L E   L I B R A R Y

    NAME: faExtractEx3
   TITLE: Example 4 for the factorAnalysis action set
 PRODUCT: VIYA Statistics
    KEYS: faExtract
   PROCS: factorAnalysis action set, faExtract action
    DATA:
    MISC:

Uses the jobratings data set from the PROC FACTOR documentation.
"""


s.loadactionset(actionset='factorAnalysis')

s.factoranalysis.faextract(
    fuzz='0.4',
    method=dict(name='ml'),
    nFactors=[2],
    reorder='true',
    rotate=dict(type='quartimin'),
    table='jobratings')

s.factoranalysis.faextract(
    fuzz='0.4',
    method=dict(name='ml'),
    nFactors=[3],
    reorder='true',
    rotate=dict(type='quartimin'),
    table='jobratings')

