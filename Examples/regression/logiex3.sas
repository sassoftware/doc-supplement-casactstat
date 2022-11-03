/****************************************************************************/
/*             S A S   S A M P L E   L I B R A R Y                          */
/*                                                                          */
/*        NAME: logiex3                                                     */
/*        TITLE: Example 3 for logistic action -- Computing Odds Ratios     */
/*      PRODUCT: VIYA Statistics                                            */
/*         KEYS: Logistic regression analysis,                              */
/*               Binary response data                                       */
/*        PROCS: regression action set, logistic action                     */
/*         DATA: From Example 1 for the logistic action                     */
/*      SUPPORT: Bob Derr                                                   */
/*         MISC:                                                            */
/*                                                                          */
/****************************************************************************/

/*
   This example uses the data and selected model from the Binary
   Logistic Regression example to demonstrate how to request odds ratios.
*/


proc cas;
regression.logistic /
    display="oddsratios",
    model={depvar={{name="y", options={event="1"}}}, effects={"x2", "x8"}},
    oddsratios={vars={"x2", "x8"}},
    table="getStarted";
run;

proc cas;
regression.logistic /
    display="oddsratios",
    model={depvar={{name="y", options={event="1"}}},
           effects={{interaction="BAR", vars={"x2", "x8"}}}},
    oddsratios={vars={"x2", "x8"}},
    table="getStarted";
run;

proc cas;
regression.logistic /
    display="oddsratios",
    model={depvar={{name="y", options={event="1"}}},
           effects={{interaction="BAR", vars={"x2", "x8"}}}},
    oddsratios={vars={{at={{value="2", var="x8"}}, var="x2"},
                      {at={{value={5, 10}, var="x2"}}, var="x8"}}},
    table="getStarted";
run;

proc cas;
regression.logistic /
    class={"C"},
    display="oddsratios",
    model={depvar={{name="y", options={event="1"}}},
           effects={{interaction="BAR", vars={"C", "x2", "x8"}}}},
    oddsratios={vars={{at={{level={"A", "B"}, var="C"}, {values={1}, var="x8"}},
                       unit={5, 10},
                       var="x2"}}},
    table="getStarted";
run;

proc cas;
regression.logistic /
    class={"C"},
    display="oddsratios",
    model={depvar={{name="y", options={event="1"}}},
           effects={{interaction="BAR", vars={"C", "x2", "x8"}}}},
    oddsratios={at={{level={"A", "B"}, var="C"}, {values={1}, var="x8"}},
                unit={{value={5, 10}, var="x2"}},
                vars="x2"},
    table="getStarted";
run;

