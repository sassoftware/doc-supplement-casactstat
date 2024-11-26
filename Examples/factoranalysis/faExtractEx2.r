if(FALSE){
S A S   S A M P L E   L I B R A R Y

    NAME: faExtractEx2
   TITLE: Example 4 for the factorAnalysis action set
 PRODUCT: VIYA Statistics
    KEYS: faExtract
   PROCS: factorAnalysis action set, faExtract action
    DATA:
    MISC:

Uses the socioeconomics data set from the PROC FACTOR documentation.
}


m <- cas.builtins.loadActionSet(s, actionset='factorAnalysis')

cas.factorAnalysis.faExtract(s,
    method=list(heywood='bound', name='prinit'),
    nFactors=c(2),
    table='socioeconomics')

cas.factorAnalysis.faExtract(s,
    method=list(heywood='bound', name='ml'),
    nFactors=c(2),
    table='socioeconomics')

