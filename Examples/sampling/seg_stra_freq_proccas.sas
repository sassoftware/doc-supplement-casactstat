/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: seg_stra_freq_proccas                              */
/*   TITLE: Example for stratified Action                       */
/*    DESC: Segment-Stratified Sampling for Each Target When a Freq Variable is Specified  */
/* PRODUCT: Viya Analytics Utility Procedures                   */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: stratified Action                                   */
/*    DATA:                                                     */
/*LANGUAGE: PROC CAS                                            */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/*****************************************************************/

data mycas.hmeq;
   set sampsio.hmeq;
   id = _N_;
   freqVar = 10;
run;

proc cas;
   loadactionset "sampling";
   action stratified result=r/table={name="hmeq",groupby={"bad"}}
      samppct=10, samppct2=20, seed=10, target={"job","reason"}, freq="freqVar",
      outputTables={names={STRAFreq="straf",SampleFreqMap="sfmap"}},
      output={casout={name="out",replace="TRUE"},
              copyvars={"id","job","reason","bad","loan","value","delinq","derog"}};
   run;
   print r.STRAFreq;
   print r.SampleFreqMap;
   run;
quit;

proc sort data= mycas.out out= myout;
by id;
run;

proc print data=myout(obs=20);
run;

