/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SANDWICH1                                           */
/*   TITLE: Example 1 for sparseReg Action                      */
/*          Analysis of Microarray Data                         */
/* PRODUCT: CASSTAT                                             */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Microarray Data                                     */
/*          Genome                                              */
/*  PROCS: sparse regresion action set; sparse regression action*/
/*    DATA:                                                     */
/* LANGUAGE: PROC CAS                                           */
/*    MISC:                                                     */
/****************************************************************/



%let nArray  = 6;
%let nDye    = 2;
%let nGene   = 500;
%let nTrt    = 2;

data mycas.microarray;
   keep  Microarray Array Gene Trt Dye Density;
   array GeneDist{&ngene};
   array ArrayEffect{&narray};
   do i = 1 to &nGene;
       GeneDist{i} = 1 + int(&nGene*ranuni(12345));
   end;
   do i = 1 to &nArray;
      ArrayEffect{i} = sqrt(0.014)*rannor(12345);
   end;

   do Microarray = 1 to &nArray;
      do Dye = 1 to &nDye;
         do k = 1 to &nGene;
            Trt   = 1 + int(&nTrt*ranuni(12345));
            Gene  = GeneDist{k};
            Array = ArrayEffect{Microarray};

            Density  = 1
                     + Dye
                     + Trt
                     + Gene/1000.0
                     + Gene*Dye/1000.0
                     + Gene*Trt/1000.0
                     + Array
                     + sqrt(0.02)*rannor(12345);
            output;
         end;
      end;
   end;
run;


proc cas;
   sandwich.sparsereg /
      table='microarray',
      sparse=true,
      class={'Microarray', 'Gene', 'Trt', 'Dye'},
      model={depVar='Density',
             effects = { 'Gene', 'Trt', 'Dye',
                         {vars={'Gene','Trt'}, interact='CROSS' },
                         {vars={'Gene','Dye'}, interact='CROSS' }
                       },
            ss3 = true
            },
      cluster={'Microarray'};
run;

