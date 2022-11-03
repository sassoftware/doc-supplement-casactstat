/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SPCEX1                                              */
/*   TITLE: Documentation Example 1 for SPC Action Set          */
/* PRODUCT: VIYA Statistics                                     */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Exception Summary                                   */
/*   PROCS: spc action set                                      */
/*    DATA:                                                     */
/* SUPPORT: Bucky Ransdell                                      */
/*                                                              */
/****************************************************************/

data mycas.Random;
   length processname $16 subgroupname $16;
   do i = 1 to 100;
      processname  = 'Process'  || left( put( i, z3. ) );
      subgroupname = 'Subgroup' || left( put( i, z3. ) );
      do subgroup = 1 to 30;
         do j = 1 to 5;
            process = rannor(123);
            output;
         end;
      end;
   end;
   drop i j;
run;


ods trace on;
proc cas;
   action spc.xChart /
      table='Random'
      exChart=true;
run;

