if(FALSE){
S A S   S A M P L E   L I B R A R Y

    NAME: faNFactorsEx2
   TITLE: Example 2 for the faNFactors action
 PRODUCT: VIYA Statistics
    KEYS: faNFactors
   PROCS: factorAnalysis action set, faNFactors action
    DATA:
    MISC:

Uses the jobratings data set from the PROC FACTOR documentation.
}


m <- cas.builtins.loadActionSet(s, actionset='factorAnalysis')

cas.factorAnalysis.faNFactors(s,
    criteria=list(list(status='inactive',
                       threshold=c(0.5, 1, 1.5),
                       type='eigenvalue'),
                  list(alpha=c(0.05, 0.1),
                       nSims=c(20000),
                       seed=c(1031, 1128),
                       type='parallel'),
                  list(status='inactive',
                       threshold=c(0.9, 0.95),
                       type='proportion'),
                  list(status='inactive', type='map2'),
                  list(status='inactive', type='map4')),
    nFactors='mean',
    priors='asmc',
    table='jobratings')

