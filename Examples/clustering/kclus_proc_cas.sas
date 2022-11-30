/***************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                */
/*                                                             */
/*    NAME: kclus_proc_cas.sas                                 */
/*   TITLE: PROC CAS example for Iris flower clustering        */
/* PRODUCT: AACAS                                              */
/*  SYSTEM: ALL                                                */
/*    KEYS:                                                    */
/*   PROCS: kclus                                              */
/*    DATA:                                                    */
/*                                                             */
/*     REF:                                                    */
/*    MISC:                                                    */
/*                                                             */
/***************************************************************/

data mycas.iris;
   set sashelp.iris;
run;

proc cas;
   action clustering.kClus
      table={name="iris"},
nClusters=5,
      init="RAND",
      seed=534,
      inputs={"SepalLength", "SepalWidth", "PetalLength", "PetalWidth"},
      output={casOut={name="kClusOutputScore", replace=True},
                      copyVars={"SepalLength", "SepalWidth",
                                "PetalLength", "PetalWidth", "Species"}},
      printIter=false,
      impute="MEAN",
      standardize='STD',
      display={names={"Nobs", "Modelinfo", "ClusterSum",
                      "IterStats", "DescStats", "WithinClusStats"}},
      outstat={name="outstat", replace="True"};
run;

proc
   print noobs data=mycas.outstat;
run;

proc
   print noobs data=mycas.kClusOutputScore(obs=10);
run;

