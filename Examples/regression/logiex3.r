if(FALSE) {
S A S   S A M P L E   L I B R A R Y

    NAME: logiex3
   TITLE: Example 3 for logistic action -- Computing Odds Ratios
 PRODUCT: VIYA Statistics
    KEYS: Logistic regression analysis,
          odds ratios
   PROCS: regression action set,logistic action
    DATA: Cox and Snell (1989, pp 10-11)
    MISC:

This section uses the data and selected model from the Binary
Logistic Regression example (logiex1.sas) to demonstrate how to
request odds ratios.
}

cas.regression.logistic(s,
    display='oddsratios',
    model=list(depvar=list(list(name='y', options=list(event='1'))),
               effects=c('x2', 'x8')),
    oddsratios=list(vars=c('x2', 'x8')),
    table='getStarted')

cas.regression.logistic(s,
    display='oddsratios',
    model=list(depvar=list(list(name='y', options=list(event='1'))),
               effects=list(list(interaction='BAR', vars=c('x2', 'x8')))),
    oddsratios=list(vars=c('x2', 'x8')),
    table='getStarted')

cas.regression.logistic(s,
    display='oddsratios',
    model=list(depvar=list(list(name='y', options=list(event='1'))),
               effects=list(list(interaction='BAR', vars=c('x2', 'x8')))),
    oddsratios=list(vars=list(list(at=list(list(value='2', var='x8')),
                                   var='x2'),
                              list(at=list(list(value=c(5, 10), var='x2')),
                                   var='x8'))),
    table='getStarted')

cas.regression.logistic(s,
    class=c('C'),
    display='oddsratios',
    model=list(depvar=list(list(name='y', options=list(event='1'))),
               effects=list(list(interaction='BAR', vars=c('C', 'x2', 'x8')))),
    oddsratios=list(vars=list(list(at=list(list(level=c('A', 'B'), var='C'),
                                           list(values=c(1), var='x8')),
                                   unit=c(5, 10),
                                   var='x2'))),
    table='getStarted')

cas.regression.logistic(s,
    class=c('C'),
    display='oddsratios',
    model=list(depvar=list(list(name='y', options=list(event='1'))),
               effects=list(list(interaction='BAR', vars=c('C', 'x2', 'x8')))),
    oddsratios=list(at=list(list(level=c('A', 'B'), var='C'),
                            list(values=c(1), var='x8')),
                    unit=list(list(value=c(5, 10), var='x2')),
                    vars='x2'),
    table='getStarted')

