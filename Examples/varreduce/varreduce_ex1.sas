/*****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                  */
/*                                                               */
/*     NAME: varreduce_dat1                                      */
/*    TITLE: Analyzing Framingham Heart Study Data               */
/*  PRODUCT: VIYA Statistics                                     */
/*   SYSTEM: ALL                                                 */
/*     KEYS: Regression Analysis                                 */
/*    PROCS: varReduce action set; super action                  */
/*     DATA:                                                     */
/* LANGUAGE: PROC CAS                                            */
/*                                                               */
/*  SUPPORT: Ruiwen Zhang                                        */
/*     MISC:                                                     */
/*****************************************************************/

   data mycas.Heart;
      set sashelp.Heart;
   run;

proc cas;
   action varReduce.super /
   table={name='Heart'},
   analysis='DSC',
   tech='COV',
   maxsteps=15,
   BIC=true,
   class={'Status','Sex','Chol_Status', 'BP_Status',
   	     'Weight_Status','Smoking_Status'},
   model={depvars={'Status'},
         effects={'Sex', 'AgeAtStart', 'Height', 'Weight', 'Diastolic',
   	             'Systolic', 'MRW', 'Smoking', 'Cholesterol', 'Chol_Status', 'BP_Status',
   	             'Weight_Status', 'Smoking_Status'}};
run;
quit;

