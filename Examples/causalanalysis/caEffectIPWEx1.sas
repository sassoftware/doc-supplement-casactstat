/*
S A S   S A M P L E   L I B R A R Y

    NAME: caEffectIPWEx1
   TITLE: Example 1 for IPW estimation with caEffect action
 PRODUCT: VIYA Statistics
    KEYS: caEffect
   PROCS: causalAnalysis action set, caEffect action
    DATA:
    MISC:

Uses the SmokingWeight data set from the PROC CAUSALTRT
documentation. Fits a propensity score model by using
regression.logistic.
*/


proc cas;
regression.logistic /
    class={"Sex", "Race", "Education", "Exercise", "Activity"},
    model={depvar="Quit",
           effects={"Sex", "Race", "Education", "Exercise", "Activity", "Age",
                    "YearsSmoke", "PerDay"}},
    store={name="logTrtModel", replace="true"},
    table="SmokingWeight";
run;

proc cas;
aStore.score /
    copyVars={"Quit", "Change"},
    out={name="logScored"},
    rstore="logTrtModel",
    table="SmokingWeight";
run;

proc cas;
causalAnalysis.caEffect /
    difference={{refLev="0"}},
    inference="TRUE",
    outcomeVar="Change",
    pom={{trtLev="1", trtProb="P_Quit1"}, {trtLev="0", trtProb="P_Quit0"}},
    table="logScored",
    treatVar="Quit";
run;

proc cas;
causalAnalysis.caEffect /
    difference={{refLev="0"}},
    outcomeVar="Change",
    pom={{trtLev="1", trtProb="P_Quit1"}, {trtLev="0", trtProb="P_Quit0"}},
    table="logScored",
    treatVar={condEvent="1", name="Quit"};
run;

