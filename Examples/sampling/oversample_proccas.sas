/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: oversample_proccas                                  */
/*   TITLE: Example for oversample Action                       */
/*    DESC: Oversampling                                        */
/* PRODUCT: Viya Analytics Utility Procedures                   */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: oversample Action                                   */
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
   action oversample result=r/table={name="hmeq", groupby={"bad"}}
      event="1" samppctevt=90 eventprop=0.5 partind="true" seed=10
      output={casout={name="out3",replace="TRUE"},
              copyvars={"job","loan","value","delinq","derog"},
       partindname='MyPartInd' freqname='MyFreq'};
   run;
   print r.OVERFreq; run;
run;

proc print data=mycas.out3(obs=20);
run;

