/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*     NAME: modelmatgs1                                       */
/*    TITLE: Example for the modelMatrix Action                 */
/*     DESC: Creating the Design Matrix                         */
/*  PRODUCT: VIYA Statistics                                    */
/*   SYSTEM: ALL                                                */
/*     KEYS: Regression Modeling, Design Matrix.                */
/*           simulated data                                     */
/*    PROCS: regression action set; modelMatrix action          */
/*    DATA:                                                     */
/* LANGUAGE: PROC CAS                                           */
/*                                                              */
/*     MISC:                                                    */
/*                                                              */
/****************************************************************/

/*****************************************************************
Producing a Design Matrix for Regression Models
*****************************************************************/

/*
This example produces a simulated analysis table with 20 observations.
This table contains a target y, one classification variable c,
and one continuous variable x, and variables named frq and wgt
that you can use for FREQ and WEIGHT statements. Variable index is used for
the purpose of choosing rows for display purposes. Variable byVar is used for
identifying and assigning BY groups.
*/

title 'Producing a Design Matrix for Regression Models';


data mycas.sample / sessref=mysess single=yes;
    call streamInit(1);
    do byVar=1 to 2;
      do i=1 to 10;
               if byVar=1 then c=rand("Integer",0,3);
         else  if byVar=2 then c=rand("Integer",0,1);
         x=rand("Normal");
         y=1;
         wgt=1;
         if i=5 and byVar=2 then frq  = -1; else frq=1;
         index + 1;
         output;
      end;
    end;
run;


   regression.modelMatrix  result=myresult /
      table='sample',
      class={'/c/'},
      model={ depVar='y',
              effects={'/c/','x'}
            },
      outDesign={casOut={name='designMat',
                         replace='True'
                        },
                 prefix='param'
                };
   run;

   print myresult['NObs'];
   run;

   describe myresult;
   run;

   regression.modelMatrix /
      table='sample',
      class={'/c/'},
      model={ depVar='y',
              effects={'/c/','x'}
            },
      outDesign={casOut={name='designMat',
                         replace='True'
                        },
                 prefix='param'
                },
      display={names={'OutDesignInfo','NObs'}};
   run;

   regression.modelMatrix /
      table='sample',
      class={'/c/'},
      model={ depVar='y',
              effects={'/c/','x'}
            },
      outDesign={casOut={name='designMat',
                         replace='True'
                        },
                 prefix='param'
                },
      outputTables={names={'OutDesignInfo', 'NObs'}};
   run;

   proc print data=mycas.NObs;
   run;

   regression.modelMatrix  /
      table={name='sample', groupBy='byVar'},
      nThreads=1,
      class  = {'c'},
      spline = {{name='spl',vars={'x'}}},
      model ={
             depVar={'y'},
             effects={'x','c','spl',
                      {vars={'x','c'}, interact='CROSS'}
                     }
             },
     freq   = 'frq',
     weight = 'wgt',
     outDesign={casOut={name='designMat',
                        replace='True'
                       },
                prefix  ='param',
                copyVars={'c', 'frq', 'index'}
               };
   run;

data designMat;
  set mycas.designMat;
run;

proc print data=designMat;
  format BEST 5. param1-param17;
  var index c frq param1-param7 param17;
  where
    (index < 11) or
    (index = 15);
run;

