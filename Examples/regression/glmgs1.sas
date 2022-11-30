/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*     NAME: glmgs1                                             */
/*    TITLE: Example for glm Action                             */
/*     DESC: Model Selection with Validation                    */
/*  PRODUCT: VIYA Statistics                                    */
/*   SYSTEM: ALL                                                */
/*     KEYS: Model Selection, Validation.                       */
/*           simulated data                                     */
/*    PROCS: regression action set; glm action                  */
/*    DATA:                                                     */
/* LANGUAGE: PROC CAS                                           */
/*                                                              */
/*     MISC:                                                    */
/*                                                              */
/****************************************************************/

/*****************************************************************
Model Selection with Validation
*****************************************************************/

/*
This example produces simulated analysis table with 1 million observations.
This table contains a target y, three classification variables c1-c3,
twenty continuous variables x1-x20, and variables named Role and
that you can use to assign observations to the training, validation, and
testing roles. In this case, each role has 5,000 observations.
*/

title 'Model Selection with Validation';

%let nTotalObs=1000000;
%let seed=1;
data mycas.analysisData / sessref=mysess single=no;
    drop i j c3Num nObsPerThread nExtras rew;
    length c3$ 7;

    array x{20} x1-x20;
    call streamInit(&seed);
    nObsPerThread  = int(&nTotalObs/_nthreads_);
    nExtras        = mod(&nTotalObs,_nthreads_);
    if _threadid_ <= nExtras then nObsPerThread =  nObsPerThread + 1;

    do i=1 to nObsPerThread;

       id = (_threadid_-1)*nObsPerThread +i;
       if _threadid_ > nExtras then id=id+nExtras;
       rew = rand('rewind', id);

       do j=1 to 20;
          x{j} = rand('UNIFORM');
       end;

       if  rand('UNIFORM') < 0.4 then byVar='A';
                                 else byVar='B';

       c1 = 1 + mod(id,8);
       c2 = rand('BERNOULLI',0.6);

       if      id < (0.001 * &nTotalObs) then do; c3 = 'tiny';     c3Num=1;end;
       else if id < (0.3   * &nTotalObs) then do; c3 = 'small';    c3Num=1;end;
       else if id < (0.7   * &nTotalObs) then do; c3 = 'average';  c3Num=2;end;
       else if id < (0.9   * &nTotalObs) then do; c3 = 'big';      c3Num=3;end;
       else                                   do; c3 = 'huge';     c3Num=5;end;

       yTrue = 10 + x1 + 2*x5 + 3*x10 + 4*x20  + 3*x1*x7 + 8*x6*x7
                  + 5*c3Num   + 8*(c1=7) + 8*(c1=3)*c2;

       error = 5*rand('NORMAL');

       y = yTrue + error;

            if mod(id,3)=1 then Role = 'TRAIN';
       else if mod(id,3)=2 then Role = 'VAL';
       else                     Role = 'TEST';

       output;
   end;
run;

proc cas;
   regression.glm  /
      table='analysisData',
      target='y',
      inputs={'c1','c2','c3','x1','x2','x3'},
      nominals={'c1','c2'};
run;

   regression.glm  /
      table='analysisData',
      class={'/c/'},
      model={ depVar='y',
              effects={'/c/','/x/'}
            },
      selection={method='STEPWISE'};
 run;

   regression.glm  result=myresult /
      table='analysisData',
      class={'/c/'},
      model={ depVar='y',
              effects={'/c/','/x/'}
            },
      selection={method='STEPWISE'};
 run;

    print myresult['Summary.SelectedEffects']
          myresult['SelectedModel.ParameterEstimates'];
 run;

   describe myresult;
 run;

    regression.glm  /
      table='analysisData',
      class={'/c/'},
      model={ depVar='y',
              effects={'/c/','/x/'}
            },
      selection={method='FORWARD'},
      display={names={'ANOVA','FitStatistics'} };
run;

    regression.glm  /
      table='analysisData',
      class={'/c/'},
      model={ depVar='y',
              effects={'/c/','/x/'}
            },
      selection={method='STEPWISE',details='ALL',maxsteps=3},
      outputTables={names={'NObs','Anova'}};
run;

 proc print data=mycas.anova;
 run;

 proc cas;
    regression.glm  /
      table='analysisData',
      class={'/c/'},
      model={ depVar='y',
              effects={'/c/','/x/'}
            },
      selection={method='FORWARD',details='ALL',maxsteps=3},
      outputTables={names={'Step1.Anova'='myStep1Anova'}};
 run;

  proc print data=mycas.myStep1Anova;
  run;

 proc cas;
    regression.glm  /
      table='analysisData',
      partByVar={name='Role',train='TRAIN',validate='VAL',test='TEST'},
      class={'/c/'},
      model={ depVar='y',
              effects={  '/c/',
                         { vars={'c1','c2'},interact='CROSS' },
                         { vars='/x/'      ,interact='BAR'   ,maxinteract=2 }
                      }
            },
      selection={method='FORWARDSWAP',choose='VALIDATE',hierarchy='SINGLE'};
 run;

   regression.glm  /
      table='analysisData',
      partByVar={name='Role',train='TRAIN',validate='VAL',test='TEST'},
      class={ 'c2','c3',
              {vars='c1',split=true}
            },
      model={ depVar='y',
              effects={  '/c/',
                         { vars={'c1','c2'},interact='CROSS' },
                         { vars='/x/'      ,interact='BAR'   ,maxinteract=2 }
                      }
            },
      selection={method='FORWARDSWAP',choose='VALIDATE',hierarchy='SINGLE'};
 run;

   regression.glm  /
      table='analysisData',
      attributes={ {name='c1',format='roman4.'} },
      class='/c/',
      model={ depVar='y',
              effects={  '/c/', '/x/'}
            };
 run;

   regression.glm  /
      table='analysisData',
      attributes={ {name='c1',format='roman4.'} , {name='y',label='Response'} },
      class='/c/',
      model={ depVar='y',
              effects={  '/c/', '/x/'}
            },
      output={casout='myOutputTable',pred='Predicted',resid='Residual',
              h='Leverage',cooksD='CooksD', copyVars={'/c/','/x/','y'}
             };
 run;

    table.columnInfo / table='myOutputTable';
run;

   regression.glm /
      table={ name='analysisData', groupBy='byVar'},
      attributes={ {name='c1',format='roman4.'} , {name='y',label='Response'} },
      class='/c/',
      model={ depVar='y',
              effects={  '/c/', '/x/'}
            },
      display={names={'NObs','ANOVA'},traceNames=true};
  run;

