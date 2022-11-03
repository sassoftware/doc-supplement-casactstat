/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*     NAME: glmscoregs1                                        */
/*    TITLE: Example for glm Action                             */
/*     DESC: Linear Regression                                  */
/*  PRODUCT: VIYA Statistics                                    */
/*   SYSTEM: ALL                                                */
/*     KEYS:  Model Selection, Scoring,                         */
/*           simulated data                                     */
/*    PROCS: regression action set; glm and glmScore actions    */
/*    DATA:                                                     */
/* LANGUAGE: PROC CAS                                           */
/*                                                              */
/*  SUPPORT: Robert Cohen                                       */
/*     MISC:                                                    */
/*                                                              */
/****************************************************************/


/*****************************************************************
Model Selection and Scoring New Data
*****************************************************************/

/*
This example produces a simulated analysis table and two tables
that contain data to be scored by using a model that is trained on
the analysis table. The analysis table contains a target y,
two classification variables c1 and c2 and , two continuous
variables x1 and x2.
*/

title 'Model Selection and Scoring';

 data mycas.analysisData;

    call streamInit(1);

    do id=1 to 100;
       x1 = rand('UNIFORM');
       x2 = rand('NORMAL');
       c1 = 1 + mod(id,3);
       c2 = rand('BERNOULLI',0.6);

       y = 1 + x1 + c1 + 0.01*rand('NORMAL');

       output;
   end;
 run;

proc cas;
   regression.glm
      table='analysisData',
      class={'c1','c2'},
      model={depvar='y',
             effects={'c1', 'c2', 'x1', 'x2'}},
      store={name='myModel', replace=true},
      selection={method='forward'},
      output={casOut={name='out1', replace=true},
              copyVars='ALL',
              pred='pred', resid='resid', rstudent='rstudent'};
run;quit;

proc cas;
   regression.glmScore
      restore='myModel',
      table='analysisData',
      fitData='true',
      casOut={name='out2', replace=true},
      copyVars='ALL',
      pred='pred', resid='resid', rstudent='rstudent';
run;

proc print data=mycas.out1(where=(id<=5));
run;

proc print data=mycas.out2(where=(id<=5));
run;

proc compare data=mycas.out1 compare=mycas.out2;
run;

 data mycas.scoreData1;
    call streamInit(3);

    do id=1 to 5;
       x1 = rand('UNIFORM');
       c1 = 1 + mod(id,3);
       y  = 1 + x1 + c1 + 0.01*rannor(1);
       output;
    end;
 run;

 data mycas.scoreData2;
    call streamInit(3);

    do id=1 to 5;
       x1 = rand('UNIFORM');
       c1 = 1 + mod(id,4);
       output;
    end;
 run;

proc cas;
   regression.glmScore
      restore='myModel',
      table='scoreData1',
      casOut={name='out3', replace=true},
      copyVars='ALL',
      pred='pred', resid='resid', rstudent='rstudent';
run;

proc print data=mycas.out3;
run;


proc cas;
   regression.glmScore
      restore='myModel',
      table='scoreData2',
      casOut={name='out4', replace=true},
      copyVars='ALL',
      pred='pred';
run;

proc print data=mycas.out4;
run;

