/*
 S A S   S A M P L E   L I B R A R Y

     NAME: slscoreex1
     TITLE: Example 1 for slScore action
     PRODUCT: VIYA Statistics
     KEYS: SUPERLEARNER
     PROCS: superLearner action set, slScore action
     DATA:
     MISC:

 Used the modelFit store created in sltrainex1 to score new
 data.
*/

data mycas.Baseball;
   set Sashelp.Baseball;
run;

proc cas;
   superLearner.slScore
      table='baseball',
      restore='modelFit',
      casOut={name='scoredData1', replace=true};
   run;
quit;

proc print data=mycas.scoredData1(obs=10);
run;

proc cas;
   superLearner.slScore
      table='baseball',
      restore='modelFit',
      margins={{at={{value='1', var='nHome'}}, name='Scenario1'},
               {at={{value='10', var='nHome'}, {value='60', var='nRuns'}},
                  name='Scenario2'}},
      marginPredOut=true,
      casOut={name='scoredData2', replace=true};
   run;
quit;

proc print data=mycas.scoredData2(obs=10);
run;

