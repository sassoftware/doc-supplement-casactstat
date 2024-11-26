
S A S   S A M P L E   L I B R A R Y

    NAME: faNFactorsEx2
   TITLE: Example 2 for the faNFactors action
 PRODUCT: VIYA Statistics
    KEYS: faNFactors
   PROCS: factorAnalysis action set, faNFactors action
    DATA:
    MISC:

Uses the jobratings data set from the PROC FACTOR documentation.



s:loadactionset{actionset="factorAnalysis"}

s:factorAnalysis_faNFactors{
table='jobratings',
criteria={
   {type='eigenvalue', threshold={0.50,1.00,1.50}, status='inactive'},
   {type='parallel', alpha={0.05,0.10}, nSims={20000}, seed={1031,1128}},
   {type='proportion', threshold={0.90,0.95}, status='inactive'},
   {type='map2', status='inactive'},
   {type='map4', status='inactive'}
},
nFactors='mean',
priors='asmc'
}

