/*
S A S   S A M P L E   L I B R A R Y

    NAME: sltrainex1
   TITLE: Example 1 for slTrain action
 PRODUCT: VIYA Statistics
    KEYS: SUPERLEARNER
   PROCS: superLearner action set, slTrain action
    DATA:
    MISC:
*/


data mycas.Baseball;
   set Sashelp.Baseball;
run;

proc cas;
superLearner.slTrain /
    inputs={"nAtBat", "nHits", "nHome", "nRuns", "nRBI", "nBB", "yrMajor",
            "crAtBat", "crHits", "crHome", "league", "division", "crRuns",
            "crRbi", "crBB", "nOuts", "nAssts", "nError"},
    k="6",
    library={{modelType="GLM", name="glm"},
             {modelType="DTREE", name="dtree"},
             {modelType="BARTGAUSS",
              name="bart",
              trainOptions={inputs={"nAtBat", "nHits", "nHome", "nRuns", "nRBI",
      "nBB", "yrMajor", "crAtBat", "crHits", "crHome", "league", "division",
      "crRuns", "crRbi", "crBB", "nOuts", "nAssts", "nError"},
                            nMC="100",
                            nTree="10",
                            nominals={"league", "division"},
                            table="baseball",
                            target="logSalary"}}},
    nominals={"league", "division"},
    seed="846203",
    store={name="modelFit", replace="true"},
    table="baseball",
    target="logSalary";
run;

