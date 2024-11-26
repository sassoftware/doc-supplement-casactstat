if(FALSE){
S A S   S A M P L E   L I B R A R Y

    NAME: faExtractEx3
   TITLE: Example 4 for the factorAnalysis action set
 PRODUCT: VIYA Statistics
    KEYS: faExtract
   PROCS: factorAnalysis action set, faExtract action
    DATA:
    MISC:

Uses the jobratings data set from the PROC FACTOR documentation.
}


m <- cas.builtins.loadActionSet(s, actionset='factorAnalysis')

cas.factorAnalysis.faExtract(s,
    fuzz='0.4',
    method=list(name='ml'),
    nFactors=c(2),
    reorder='true',
    rotate=list(type='quartimin'),
    table='jobratings')

cas.factorAnalysis.faExtract(s,
    fuzz='0.4',
    method=list(name='ml'),
    nFactors=c(3),
    reorder='true',
    rotate=list(type='quartimin'),
    table='jobratings')

