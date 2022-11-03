/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MIXEDGS1                                            */
/*   TITLE: Example for mixed Action                            */
/*    DESC: Student Scores on Math Tests                        */
/* PRODUCT: VIYA Statistics                                     */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Mixed Linear Models                                 */
/*   PROCS: mixed action set; mixed action                      */
/* LANGUAGE: PROC CAS                                           */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: Tianlin Wang                                        */
/*     REF:  Stroup (1989).                                     */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/
title 'Student Scores on Math Tests';

data mycas.SchoolSample;
   do SchoolID = 1 to 1000;
      do nID = 1 to 50;
         Neighborhood = (SchoolID-1)*15 + nId;
         bInt   = 15*ranuni(1);
         bTime  = 15*ranuni(1);
         bTime2 =   ranuni(1);
         do sID = 1 to 2;
            do Time = 1 to 4;
               Math = bInt + bTime*Time + bTime2*Time*Time + rannor(2);
               output;
               end;
            end;
         end;
      end;
run;

proc cas;
action mixed.mixed /
   table={name='SchoolSample'},
   class={{vars={'Neighborhood', 'SchoolID'}}},
   model={depVars={{name='Math'}},
          effects={{vars={'Time'}},
                   {vars={'Time','Time'},interaction='CROSS'}},
          printsol = TRUE},
   random={{noint=FALSE,
            effects={{vars={'Time'}},
                     {vars={'Time','Time'},interaction='CROSS'}},
            type='RANDOM',
            subject= {{vars={'Neighborhood','SchoolID'},interaction='CROSS'}},
            covType='UN',
            printsol=TRUE}};
run;

