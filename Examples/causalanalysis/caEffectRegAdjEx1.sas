/*
S A S   S A M P L E   L I B R A R Y

    NAME: caEffectIPWEx1
   TITLE: Example 1 for RegAdj estimation with caEffect action
 PRODUCT: VIYA Statistics
    KEYS: caEffect
   PROCS: causalAnalysis action set, caEffect action
    DATA:
    MISC:

Uses the birthwgt data set from the PROC CAUSALMED
documentation. Fits an outcome model by using
decisionTree.gbtreeTrain action.
*/


data mycas.birthwgt;
   set sashelp.birthwgt;
run;

proc cas;
decisionTree.gbtreeTrain /
    inputs={"Smoking", "AgeGroup", "Married", "Drinking", "SomeCollege"},
    nTrees="100",
    nominals={"Smoking", "AgeGroup", "Married", "Drinking", "SomeCollege",
              "Death"},
    savestate={name="gbOutMod", replace="TRUE"},
    table="birthwgt",
    target="Death";
run;

proc cas;
causalAnalysis.caEffect /
    outcomeModel={predName="P_DeathYes", restore="gbOutMod"},
    outcomeVar={event="Yes", type="Categorical"},
    pom={{trtLev="Yes"}, {trtLev="No"}},
    table="birthwgt",
    treatVar="Smoking";
run;

proc cas;
table.alterTable /
    columns={{name="Smoking", rename="tempSmoking"}},
    name="birthwgt";
run;

proc cas;
aStore.score /
    copyVars={"tempSmoking", "AgeGroup", "Married", "Drinking", "SomeCollege"},
    out={name="gbPredData", replace="True"},
    rstore={name="gbOutMod"},
    table={computedVars={{name="Smoking"}},
           computedVarsProgram="Smoking='Yes'",
           name="birthwgt"};
run;

proc cas;
table.alterTable /
    columns={{name="P_DeathYes", rename="SmokingPred"}},
    name="gbPredData";
run;

proc cas;
aStore.score /
    copyVars={"tempSmoking", "SmokingPred"},
    out={name="gbPredData", replace="True"},
    rstore={name="gbOutMod"},
    table={computedVars={{name="Smoking"}},
           computedVarsProgram="Smoking='No'",
           name="gbPredData"};
run;

proc cas;
table.alterTable /
    columns={{name="P_DeathYes", rename="NoSmokingPred"},
             {name="tempSmoking", rename="Smoking"}},
    name="gbPredData";
run;

proc cas;
causalAnalysis.caEffect /
    outcomeVar={event="Yes", type="Categorical"},
    pom={{predOut="SmokingPred", trtLev="Yes"},
         {predOut="NoSmokingPred", trtLev="No"}},
    table="gbPredData",
    treatVar="Smoking";
run;

