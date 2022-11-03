/***************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                */
/*                                                             */
/*    NAME: kclus_proc_cas_kproto.sas                          */
/*   TITLE: PROC CAS example for baseball data clustering      */
/* PRODUCT: AACAS                                              */
/*  SYSTEM: ALL                                                */
/*    KEYS:                                                    */
/*   PROCS: kclus                                              */
/*    DATA:                                                    */
/*                                                             */
/* SUPPORT: Yingjian Wang                                      */
/*     REF:                                                    */
/*    MISC:                                                    */
/*                                                             */
/***************************************************************/

data mycas.baseball;
   set sashelp.baseball;
run;

proc cas;
   action clustering.kClus
      table={name="baseball"},
      inputs={"CrAtBat", "CrHits", "CrRuns", "CrRbi", "CrBB",
              "Team", "League", "Division", "Position", "Div"},
      nClusters=10,
      maxIters=10,
      distanceNom="RELATIVEFREQ",
      estimateNClusters={method="ABC", B=10, minClusters=2,
                         criterion="ALL", align="PCA"},
      kPrototypeParams={method="USERGAMMA", value=10},
      output={casOut={name="kClusOutputScore", replace=true},
              copyVars={"CrAtBat", "CrHits", "CrRuns", "CrRbi", "CrBB",
                        "Team", "League", "Division", "Position", "Div"}},
      display={names={"Modelinfo", "ClusterSumIntNom"}};
run;

