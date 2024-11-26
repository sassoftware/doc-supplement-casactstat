if(FALSE){
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
}


m <- cas.builtins.loadActionSet(s, actionset='factorAnalysis')

cas.factorAnalysis.faNFactors(s,
    criteria=list(list(type='eigenvalue'),
                  list(threshold=c(0.9), type='proportion')),
    table='testdata')

m <- cas.builtins.loadActionSet(s, actionset='factorAnalysis')

cas.factorAnalysis.faNFactors(s,
    criteria=list(list(threshold=c(0.9, 0.95, 0.99), type='proportion')),
    priors='one',
    table='testdata')

