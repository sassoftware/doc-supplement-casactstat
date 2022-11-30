/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SIMSYS1                                             */
/*   TITLE: Documentation Example 1 for simSystem Action Set    */
/* PRODUCT: VIYA Statistics                                     */
/*  SYSTEM: ALL                                                 */
/*    KEYS: simulation skewness kurtosis                        */
/*   PROCS: simSystem, regression, simple action sets           */
/*    DATA:                                                     */
/*                                                              */
/*    MISC:                                                     */
/****************************************************************/

/*
/ Generate nonnormal data with skewness 1.5 and kurtosis 7.
/---------------------------------------------------------------------*/

proc cas;
   simSystem.simsk /
      seed=12345
      nsimulations=100
      skewness=1.5
      kurtosis=7
      outtable={ name="Sim" };
run;

/*
/ Perform ANOVA on the resulting sample.
/---------------------------------------------------------------------*/

proc cas;
   ds2.runds2 program="
      data sim / overwrite=yes;
         declare double a y;
         method run();
            set sim;
            a = mod( iObs - 1, 5 ) + 1;
            y = Variate;
         end;
      enddata;";
   run;
   regression.glm /
      table={ name="Sim" }
      class={ "a" }
      model={ depVar="y" effects={ "a" } }
      display={ names="Anova" };
   run;
quit;

/*
/ Use simsk with an input data set to generate 1,000 samples
/ of size 100 from the Pearson distribution with skewness 1.5 and
/ kurtosis 7.
/---------------------------------------------------------------------*/

proc cas;
   simSystem.simsk /
      seed=12345
      skewness=1.5
      kurtosis=7
      nsimulations=100
      nreplicates=1000
      outtable={name="Sim" replace=True};
run;

/*
/ Evaluate how often F test is rejected at the 10%, 5%, and 1% levels.
/---------------------------------------------------------------------*/

proc cas;
   ds2.runds2 program="
      data sim / overwrite=yes;
         declare double a y;
         method run();
            set sim;
            a = mod( iObs - 1, 5 ) + 1;
            y = Variate;
         end;
      enddata;";
   run;
   regression.glm /
      table={ name="Sim" groupby={name="Rep"} }
      class={ "a" }
      model={ depVar="y" effects={ "a" } }
      display={ excludeall=True }
      outputTables={names={Anova="AOV"}}
      ;
   run;
   ds2.runds2 program="
      data AOV / overwrite=yes;
         declare double Sig10 Sig05 Sig01;
         method run();
            set AOV;
            if ( Source = 'Model' );
            Sig10 = ( ProbF < 0.10 );
            Sig05 = ( ProbF < 0.05 );
            Sig01 = ( ProbF < 0.01 );
         end;
      enddata;";
   run;
   simple.summary /
      table={name="AOV"},
      inputs={"Sig10", "Sig05", "Sig01"},
      casOut={name="AOV_summary", replace=True}
      ;
   run;
quit;
proc print data=mycas.AOV_summary noobs;
   var _Column_ _Mean_;
run;

