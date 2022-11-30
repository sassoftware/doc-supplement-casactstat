/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*     NAME: genscoregs1                                        */
/*    TITLE: Example for genmod Action                          */
/*     DESC: Poisson Regression                                 */
/*  PRODUCT: VIYA Statistics                                    */
/*   SYSTEM: ALL                                                */
/*     KEYS: Genmod regression analysis,                        */
/*          Count  response data                                */
/*    PROCS: regression action set; genmod action               */
/*    DATA:                                                     */
/* LANGUAGE: PROC CAS                                           */
/*                                                              */
/*     MISC:                                                    */
/*                                                              */
/****************************************************************/

/*****************************************************************
Poisson Regression
*****************************************************************/

/*
The data consists of 100 observations on a count response
variable Y, and five numerical categorical variables C1--C5.
A main effects Poisson regression model is fit to
these data.
*/

title 'Poisson Regression';

data mycas.getStarted;
  input C1-C5 Y @@;
  id = _n_;
  datalines;
0 3 1 1 3 2   2 3 0 3 1 2   1 3 2 2 2 1   1 2 0 0 3 2   0 2 1 0 1 1
0 2 1 0 2 1   1 2 1 0 1 0   0 2 1 1 2 1   1 2 0 0 1 0   0 1 1 3 3 2
2 2 2 2 1 1   0 3 2 0 3 2   2 2 2 0 0 1   0 2 0 2 0 1   1 3 0 0 0 0
1 2 1 2 3 2   0 1 2 3 1 1   1 1 0 0 1 0   1 3 2 2 2 0   2 1 3 1 1 2
1 3 0 1 2 1   2 0 2 3 0 5   2 2 2 1 0 1   3 1 3 1 0 1   3 1 3 1 2 3
3 1 1 2 3 7   3 1 1 1 0 1   3 1 0 0 0 2   3 1 2 3 0 1   2 2 0 1 2 1
3 3 2 2 3 1   2 0 0 2 3 2   1 0 0 2 3 4   0 0 2 3 0 6   0 3 1 0 0 0
3 0 1 0 1 1   2 0 0 0 3 2   1 0 1 0 3 2   1 1 3 1 1 1   2 1 3 0 3 7
1 3 2 1 1 0   2 1 0 0 1 0   0 0 1 1 2 3   0 1 0 1 0 2   1 2 2 2 3 1
0 3 2 3 1 1   3 3 0 3 3 1   2 0 0 2 1 2   2 2 3 0 3 3   0 2 0 3 0 1
3 0 1 2 2 2   2 1 2 3 1 0   3 2 0 3 1 0   3 0 3 0 0 2   1 3 2 2 1 3
2 3 2 0 3 1   1 0 1 2 1 1   2 1 2 2 2 5   3 0 1 1 2 5   0 1 1 3 2 1
2 2 1 3 1 4   1 1 0 0 1 1   3 3 1 2 1 2   2 2 0 2 3 3   0 1 0 0 2 2
0 1 2 0 1 2   3 2 2 2 0 1   2 2 3 0 0 1   1 2 2 3 2 1   3 3 2 2 1 2
0 0 3 1 3 6   3 2 3 1 2 3   0 3 0 0 0 1   3 3 3 0 3 2   2 3 2 0 2 0
1 3 0 2 0 1   1 3 1 0 2 0   3 2 3 3 0 1   3 1 0 2 0 4   0 1 2 2 1 1
0 2 3 2 2 1   0 3 2 0 1 3   2 1 1 2 0 1   1 0 3 0 0 0   0 0 3 2 0 1
0 2 3 1 0 0   2 2 2 1 3 2   3 3 3 0 0 0   2 2 1 3 3 2   0 2 3 2 3 2
1 3 1 2 1 0   3 0 1 1 1 4   2 1 1 1 3 6   0 2 0 3 2 1   2 0 1 1 2 2
2 2 2 2 3 2   1 0 2 2 1 3   1 3 3 1 1 1   3 1 2 1 3 5   0 3 2 1 2 0
;

proc cas;
   regression.genmod
      table={name='getStarted'},
      class={'C1','C2','C3','C4','C5'},
      model={depvar='y',
             effects={'C1', 'C2', 'C3', 'C4', 'C5'},
             dist='Poisson',
             link='Log'},
      store='myModel',
      output={casOut={name='out1',replace=true},
              copyVars={'y', 'id', 'C1', 'C2', 'C3', 'C4', 'C5'},
              pred='pred',resChi='reschi',into='into'};
run;

proc cas;
   regression.genmodScore
      restore='myModel',
      table='getStarted',
      fitData='true',
      casOut={name='out2',replace=true},
      copyVars={'y', 'id', 'C1', 'C2', 'C3', 'C4', 'C5'},
      pred='pred',resChi='reschi',into='into';
run;

proc print data=mycas.out1(where=(id<=5));
run;

proc print data=mycas.out2(where=(id<=5));
run;

