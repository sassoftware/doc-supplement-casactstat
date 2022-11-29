"""
S A S   S A M P L E   L I B R A R Y

    NAME: logiex1
   TITLE: Example 1 for logistic action -- Binary Logistic Regression
 PRODUCT: VIYA Statistics
    KEYS: Logistic regression analysis,
          Binary response data
   PROCS: regression action set, logistic action
    DATA:
    MISC:

The data consists of 1,000 observations on a dichotomous response
variable y, a character variable C, and 10 numeric variables
x1--x10.  A main effects binary logistic regression model is fit to
these data.
"""

s.datastep.runcode(
    code='''
   data getStarted;
      nTotalObs=1000;
      drop c2 eta pr i rew nTotalObs nObsPerThread nExtras;
      call streaminit(1);
      nObsPerThread = int(nTotalObs/_nthreads_);
      nExtras       = mod(nTotalObs,_nthreads_);
      if _threadid_ <= nExtras then nObsPerThread = nObsPerThread + 1;
      do i=1 to nObsPerThread;
         id = (_threadid_ - 1) * nObsPerThread + i;
         if _threadid_ > nExtras then id = id + nExtras;
         rew = rand('rewind', id);
         x1=round(rand('normal')*5+10,.1); x2=round(7*rand('uniform'))/7;
         x3=round(rand('normal')*1+2,.1);  x4=round(50*rand('uniform'));
         x5=round(100*rand('uniform'));    x6=round(rand('normal')*.8+1.5,.1);
         x7=10*round(10*rand('uniform'));  x8=round(10*rand('uniform'))/10;
         x9=round(rand('normal')*3+5,.1);  x10=round(rand('normal')*2+3,.1);
         c2=rand('uniform');
         if      (c2<.1) then C='A'; else if (c2<.2) then C='B';
         else if (c2<.3) then C='C'; else if (c2<.4) then C='D';
         else if (c2<.5) then C='E'; else if (c2<.6) then C='F';
         else if (c2<.7) then C='G'; else if (c2<.8) then C='H';
         else if (c2<.9) then C='I'; else                 C='J';
         eta=1-x2-x8;
         pr= exp(eta)/(1+exp(eta));
         y=(rand('uniform') > pr);
         output;
      end;
   run;
   ''',
    single='no')

s.loadactionset(actionset='regression')

s.regression.logistic(
    class_=['C'],
    model=dict(depvar='y',
               effects=['C', 'x1', 'x2', 'x3', 'x4', 'x5', 'x6', 'x7', 'x8',
                        'x9', 'x10']),
    optimization=dict(itHist='summary'),
    outputTables=dict(names=dict(parameterestimates='pe')),
    table='getStarted')

s.regression.logistic(
    class_=['C'],
    display=dict(traceNames='true'),
    model=dict(depvar='y',
               effects=['C', 'x1', 'x2', 'x3', 'x4', 'x5', 'x6', 'x7', 'x8',
                        'x9', 'x10']),
    selection=dict(details='all', method='forward'),
    table='getStarted')

