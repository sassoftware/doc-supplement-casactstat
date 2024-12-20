/*
S A S   S A M P L E   L I B R A R Y

    NAME: caEffectDREx1
   TITLE: Example 1 for doubly robust estimation with caEffect action
 PRODUCT: VIYA Statistics
    KEYS: caEffect
   PROCS: causalAnalysis action set, caEffect action
    DATA:
    MISC:

Uses the SmokingWeight data set from the PROC CAUSALTRT
documentation. Fits a propensity score model by using
regression.logistic and an outcome model by using
bart.bartGauss.
*/


proc cas;
regression.logistic /
    class={"Sex", "Race", "Education", "Exercise", "Activity"},
    model={depvar={{name="Quit", options={event="1"}}},
           effects={"Sex", "Race", "Education", "Exercise", "Activity", "Age",
                    "YearsSmoke", "PerDay"}},
    output={casout={name="swDREstData", replace="True"},
            copyvars="All",
            pred="pTrt"},
    table="SmokingWeight";
run;

proc cas;
dataStep.runCode /
    code="
   data swDREstData;
      set swDREstData;
      pCnt = 1 - pTrt;
   run;
   ";
run;

proc cas;
bart.bartGauss /
    inputs={"Sex", "Race", "Education", "Exercise", "Quit", "Activity", "Age",
            "YearsSmoke", "PerDay"},
    nMC="200",
    nTree="100",
    nominals={"Sex", "Race", "Education", "Exercise", "Activity", "Quit"},
    seed="2156",
    store={name="bartOutMod", replace="True"},
    table="swDREstData",
    target="Change";
run;

proc cas;
causalAnalysis.caEffect /
    difference={{evtLev="1"}},
    method="aipw",
    outcomeModel={predName="P_Change", store="bartOutMod"},
    outcomeVariable="Change",
    pom={{trtLev="1", trtProb="pTrt"}, {trtLev="0", trtProb="pCnt"}},
    table="swDREstData",
    treatVar="Quit";
run;

proc cas;
causalAnalysis.caEffect /
    difference={{evtLev="1"}},
    method="tmle",
    outcomeModel={predName="P_Change", store="bartOutMod"},
    outcomeVariable="Change",
    pom={{trtLev="1", trtProb="pTrt"}, {trtLev="0", trtProb="pCnt"}},
    table="swDREstData",
    treatVar="Quit";
run;

