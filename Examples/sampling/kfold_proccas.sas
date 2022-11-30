/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: kfold_proccas                                       */
/*   TITLE: Example for \emph{k}-Fold Partitioning Action       */
/*    DESC: \emph{k}-Fold Partitioning                          */
/* PRODUCT: Viya Analytics Utility Procedures                   */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: kfold Action                                        */
/*    DATA:                                                     */
/*LANGUAGE: PROC CAS                                            */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/*****************************************************************/

data mycas.hmeq;
   set sampsio.hmeq;
run;

proc cas;
   loadactionset "sampling";
   action kfold result=r/table={name="hmeq",groupby={"BAD"}}
      k=10  seed=123
      output={casout={name="out",replace="TRUE"},
              copyvars={"bad","job","reason","loan","value","delinq","derog"},
              foldname='myfold'};
   run;
   print r.KFOLDFreq; run;
quit;

proc print data=mycas.out(obs=20);
run;

