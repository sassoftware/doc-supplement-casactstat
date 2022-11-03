/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: srs_proccas                                         */
/*   TITLE: Example  for srs Action                             */
/*    DESC: Simple Random Sampling                              */
/* PRODUCT: Viya Analytics Utility Procedures                   */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: srs Action                                          */
/*    DATA:                                                     */
/*LANGUAGE: PROC CAS                                            */
/*                                                              */
/* SUPPORT: Ye Liu                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data mycas.hmeq;
   set sampsio.hmeq;
run;

proc cas;
   loadactionset "sampling";
   action srs result=r/table={name="hmeq"}
      samppct=10 seed=10
      output={casout={name="out",replace="TRUE"},
              copyvars={"job","reason","loan","value","delinq","derog"}};
   run;
   print r.SRSFreq; run;
quit;

proc print data=mycas.out(obs=20);
run;

