#S A S   S A M P L E   L I B R A R Y
#
#   NAME: bartgaussex1
#   TITLE: Example 1 for bartGauss action
# PRODUCT: VIYA Statistics
#    KEYS: BART
#   PROCS: bart action set, bartGauss action
#    DATA:
#    MISC:
#
#The data consists of 10,000 observations on a dichotomous response
#variable y and 40 numeric variables x1--x10. A model is fit to the
#data and an astore is created for use in subsequent examples.


cas.dataStep.runCode(s,
    code='
   data trainData;
      drop i j pi w1-w40 u f1 f2 f3 f4 nTotalObs nObsPerThread nExtras;
      array x{40};
      array w{40};
      call streaminit(6524);
      nTotalObs=10000;
      pi=constant(\'pi\');
      nObsPerThread = int(nTotalObs/_nthreads_);
      nExtras       = mod(nTotalObs,_nthreads_);
      if _threadid_ <= nExtras then nObsPerThread = nObsPerThread + 1;
      do i=1 to nObsPerThread;
         u = rand(\'uniform\');
         do j=1 to dim(x);
            w{j} = rand(\'Uniform\');
            x{j} = (w{j} + u)/2;
         end;
         f1 = sin(pi * x1 * x2 );
         f2 = (x3-0.5)**2;
         f3 = x4;
         f4 = x5;
         fb = 10*f1 +20*f2+10*f3+5*f4;
         y = fb +  rand(\'Normal\');
         output;
      end;
   run;
   ',
    single='no')

m <- cas.builtins.loadActionSet(s, actionset='bart')

cas.bart.bartGauss(s,
    inputs=c('x1', 'x2', 'x3', 'x4', 'x5', 'x6', 'x7', 'x8', 'x9', 'x10', 'x11',
             'x12', 'x13', 'x14', 'x15', 'x16', 'x17', 'x18', 'x19', 'x20',
             'x21', 'x22', 'x23', 'x24', 'x25', 'x26', 'x27', 'x28', 'x29',
             'x30', 'x31', 'x32', 'x33', 'x34', 'x35', 'x36', 'x37', 'x38',
             'x39', 'x40'),
    obsLeafMapInMem='true',
    seed='9181',
    store=list(name='modelFit', replace='true'),
    table='trainData',
    target='y',
    trainInMem='true')

