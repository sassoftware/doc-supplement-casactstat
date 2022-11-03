/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: seg_stratified_proccas                              */
/*   TITLE: Example for stratified Action                       */
/*    DESC: Segment Stratified Sampling for Each Target         */
/* PRODUCT: Viya Analytics Utility Procedures                   */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: stratified Action                                   */
/*    DATA:                                                     */
/*LANGUAGE: PROC CAS                                            */
/*                                                              */
/* SUPPORT: Ye Liu                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/*****************************************************************/

data mycas.hmeq;
   set sampsio.hmeq;
run;

proc cas;
   loadactionset "sampling";
   action stratified result=r/table={name="hmeq",groupby={"bad"}}
      samppct=10, samppct2=20, seed=10, target={"job","reason"},
      outputTables={names={STRAFreq="straf",PartIndMap="pimap"}},
      output={casout={name="out",replace="TRUE"},
              copyvars={"job","reason","loan","value","delinq","derog"}};
   run;
   print r.STRAFreq;
   print r.PartIndMap;
   run;
quit;

proc print data=mycas.out(obs=20);
run;

