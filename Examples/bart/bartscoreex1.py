#S A S   S A M P L E   L I B R A R Y
#
#    NAME: bartscoreex1
#   TITLE: Example 1 for bartScore action
# PRODUCT: VIYA Statistics
#    KEYS: BART
#   PROCS: bart action set, bartScore action
#    DATA:
#    MISC:
#
#Use the modelFit store created in bartgaussex1 to score new
#data.


s.datastep.runcode(
    code='''
   data testData;
      drop i j pi w1-w40 u f1 f2 f3 f4 nTotalObs;
      array x{40};
      array w{40};
      call streaminit(1234);
      nTotalObs=1000;
      pi=constant('pi');
      do i=1 to nTotalObs;
         u = rand('uniform');
         do j=1 to dim(x);
            w{j} = rand('Uniform');
            x{j} = (w{j} + u)/2;
         end;
         f1 = sin(pi * x1 * x2 );
         f2 = (x3-0.5)**2;
         f3 = x4;
         f4 = x5;
         fb = 10*f1 +20*f2+10*f3+5*f4;
         y = fb +  rand('Normal');
         output;
      end;
   run;
   ''',
    single='yes')

s.loadactionset(actionset='bart')

s.bart.bartscore(
    casOut=dict(name='scoredData', replace='true'),
    pred='predResp',
    resid='residual',
    restore='modelFit',
    table='testData')

s.datastep.runcode(
    code='''
   data scoredData;
      set scoredData;
      sqErr = residual * residual;
   run;
   ''')

s.simple.summary(
    inputs='sqErr',
    subSet=['mean'],
    table='scoredData')

