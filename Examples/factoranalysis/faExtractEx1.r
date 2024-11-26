if(FALSE){
S A S   S A M P L E   L I B R A R Y

    NAME: faExtractEx1
   TITLE: Example 3 for the factorAnalysis action set
 PRODUCT: VIYA Statistics
    KEYS: faExtract
   PROCS: factorAnalysis action set, faExtract action
    DATA:
    MISC:

Uses the socioeconomics data set from the PROC FACTOR documentation.
}


m <- cas.builtins.loadActionSet(s, actionset='factorAnalysis')

cas.factorAnalysis.faExtract(s,
    method=list(name='principal'),
    nFactors=c(2),
    reorder='true',
    rotate=list(type='promax'),
    table='socioeconomics')

