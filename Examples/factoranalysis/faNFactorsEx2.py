"""
S A S   S A M P L E   L I B R A R Y

    NAME: faNFactorsEx2
   TITLE: Example 2 for the faNFactors action
 PRODUCT: VIYA Statistics
    KEYS: faNFactors
   PROCS: factorAnalysis action set, faNFactors action
    DATA:
    MISC:

Uses the jobratings data set from the PROC FACTOR documentation.
"""


s.loadactionset(actionset='factorAnalysis')

s.factoranalysis.fanfactors(
    criteria=[dict(status='inactive',
                   threshold=[0.5, 1, 1.5],
                   type='eigenvalue'),
              dict(alpha=[0.05, 0.1],
                   nSims=[20000],
                   seed=[1031, 1128],
                   type='parallel'),
              dict(status='inactive', threshold=[0.9, 0.95], type='proportion'),
              dict(status='inactive', type='map2'),
              dict(status='inactive', type='map4')],
    nFactors='mean',
    priors='asmc',
    table='jobratings')

