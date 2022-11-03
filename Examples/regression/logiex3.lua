--[[
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
--]]

s:regression_logistic{
   table='getStarted',
   model={depvar={{name='y', options={event='1'}}},
          effects={'x2', 'x8'}},
   oddsratios={vars={'x2', 'x8'}},
   display='oddsratios' }

s:regression_logistic{
   table='getStarted',
   model={depvar={{name='y', options={event='1'}}},
          effects={{vars={'x2', 'x8'},interaction='BAR'}}},
   oddsratios={vars={'x2','x8'}},
   display='oddsratios' }

s:regression_logistic{
   table='getStarted',
   model={depvar={{name='y', options={event='1'}}},
          effects={{vars={'x2', 'x8'},interaction='BAR'}}},
   oddsratios={vars={{var='x2',at={{var='x8',value=2}}},
                     {var='x8',at={{var='x2',value={5,10}}}}}},
   display='oddsratios' }

s:regression_logistic{
   table='getStarted',
   class={'C'},
   model={depvar={{name='y', options={event='1'}}},
          effects={{vars={'C', 'x2', 'x8'}, interaction='BAR'}}},
   oddsratios={vars={
      {var='x2',unit={5,10},at={{var='C',level={'A','B'}},
                                {var='x8',values={1}} } } }},
   display='oddsratios' }

s:regression_logistic{
   table='getStarted',
   class={'C'},
   model={depvar={{name='y', options={event='1'}}},
          effects={{vars={'C', 'x2', 'x8'},interaction='BAR'}}},
   oddsratios={vars='x2',
               unit={{var='x2',value={5,10}}},
               at={{var='C',level={'A','B'}},
                   {var='x8',values={1}} }},
   display='oddsratios' }

