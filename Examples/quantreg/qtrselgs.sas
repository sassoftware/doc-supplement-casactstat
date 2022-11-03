
/*****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                  */
/*                                                               */
/*     NAME: qtrselgs                                            */
/*    TITLE: Example for quantreg Action                         */
/*     DESC: Statistics and Salaries of Major League             */
/*             Baseball (MLB) Players in 1986                    */
/*      REF: Collier Books, 1987, The 1987 Baseball Encyclopedia */
/*           Update, Macmillan Publishing Company, New York.     */
/*                                                               */
/*  PRODUCT: VIYA Statistics                                     */
/*   SYSTEM: ALL                                                 */
/*     KEYS: Model Selection, Quantile Regression                */
/*    PROCS: quantreg action set; quantreg action                */
/* LANGUAGE: PROC CAS                                            */
/*                                                               */
/*  SUPPORT: Yonggang Yao                                        */
/*     MISC:                                                     */
/*                                                               */
/*****************************************************************/

proc contents varnum data=sashelp.baseball;
   ods select position;
run;

data mycas.baseball;
   set sashelp.baseball;
run;

proc cas;
   action quantreg.quantreg/
      table={name='baseball'},
      class={'league','division'},
      model={depvars='Salary',
             effects={'nAtBat', 'nHits', 'nHome', 'nRuns',
                      'nRBI', 'nBB', 'yrMajor', 'crAtBat',
                      'crHits', 'crHome', 'crRuns', 'crRbi',
                      'crBB', 'league', 'division', 'nOuts',
                      'nAssts', 'nError'}};
run;


proc cas;
   action quantreg.quantreg/
      table={name='baseball'},
      class={'league','division'},
      model={depvars='Salary',
             effects={'nAtBat', 'nHits', 'nHome', 'nRuns',
                      'nRBI', 'nBB', 'yrMajor', 'crAtBat',
                      'crHits', 'crHome', 'crRuns', 'crRbi',
                      'crBB', 'league', 'division', 'nOuts',
                      'nAssts', 'nError'},
             stb=1,
             clb=1},
      selection={method='forward', select='sl', sle=0.1};
run;


proc cas;
   action quantreg.quantreg/
      table={name='baseball'},
      alpha=0.1,
      class={'league','division'},
      model={depvars='Salary',
             effects={'nAtBat', 'nHits', 'nHome', 'nRuns',
                      'nRBI', 'nBB', 'yrMajor', 'crAtBat',
                      'crHits', 'crHome', 'crRuns', 'crRbi',
                      'crBB', 'league', 'division', 'nOuts',
                      'nAssts', 'nError'},
             quantile={0.1, 0.9},
             stb=1,
             clb=1},
      selection={method='backward', select='sl', sle=0.1};
run;


