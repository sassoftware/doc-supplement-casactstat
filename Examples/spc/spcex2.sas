/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SPCEX2                                              */
/*   TITLE: Documentation Example 2 for SPC Action Set          */
/* PRODUCT: VIYA Statistics                                     */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Tests for Special Causes                            */
/*   PROCS: spc action set                                      */
/*    DATA:                                                     */
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
      exChart=true
      primaryTests={test1=true test2=true test3=true test4=true};
run;

