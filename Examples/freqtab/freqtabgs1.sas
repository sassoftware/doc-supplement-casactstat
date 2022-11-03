/*****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                  */
/*                                                               */
/*     NAME: freqtabgs1                                          */
/*    TITLE: Example for freqTab Action                          */
/*  PRODUCT: VIYA Statistics                                     */
/*   SYSTEM: ALL                                                 */
/*     KEYS: Categorical Data Analysis                           */
/*    PROCS: freqTab action set; freqTab action                  */
/*     DATA:                                                     */
/* LANGUAGE: PROC CAS                                            */
/*                                                               */
/*  SUPPORT: Ning Kang                                           */
/*     MISC:                                                     */
/*****************************************************************/

/* Example: Frequency Tables */

data mycas.Color;
   input Region Eyes $ Hair $ Count @@;
   label Eyes  ='Eye Color'
         Hair  ='Hair Color'
         Region='Geographic Region';
   datalines;
1 blue  fair   23  1 blue  red     7  1 blue  medium 24
1 blue  dark   11  1 green fair   19  1 green red     7
1 green medium 18  1 green dark   14  1 brown fair   34
1 brown red     5  1 brown medium 41  1 brown dark   40
1 brown black   3  2 blue  fair   46  2 blue  red    21
2 blue  medium 44  2 blue  dark   40  2 blue  black   6
2 green fair   50  2 green red    31  2 green medium 37
2 green dark   23  2 brown fair   56  2 brown red    42
2 brown medium 53  2 brown dark   54  2 brown black  13
1 .     medium  4  1 brown .       6  1 green black   .
;

proc cas;
   action freqTab.freqTab /
      table='Color',
      weight='Count',
      tabulate={'Eyes', 'Hair',
                {vars={'Eyes', 'Hair'}},
                {vars='Region', cross={'Eyes', 'Hair'}}
               };
run;

   action freqTab.freqTab /
      table='Color',
      weight='Count',
      tabDisplay='LIST',
      tabulate={{vars={'Eyes', 'Hair'}},
                {vars={'Region', 'Eyes', 'Hair'}}
               };
run;

   action freqTab.freqTab /
      table='Color',
      weight='Count',
      tabDisplay='LIST',
      includeMissing=true,
      tabulate={'Eyes', {vars={'Eyes', 'Hair'}}};
run;

   action freqTab.freqTab /
      table='Color',
      weight='Count',
      tabDisplay={format='LIST', missingFreq=true},
      tabulate={'Eyes', {vars={'Eyes', 'Hair'}}};
run;

   action freqTab.freqTab /
      table='Color',
      attributes={{name='Region', format='roman4.', label='European Region'}},
      weight='Count',
      tabulate='Region';
run;

   action freqTab.freqTab /
      table='Color',
      weight='Count',
      display='CrossList',
      tabulate={'Eyes', 'Hair', {vars={'Region', 'Eyes', 'Hair'}}};
run;

   action freqTab.freqTab /
      table='Color',
      weight='Count',
      displayOut={names={'NObs', 'OneWayFreqs'}},
      tabulate={'Region', 'Eyes', 'Hair'};
run;

 proc print data=mycas.OneWayFreqs;
 run;

proc cas;
   action freqTab.freqTab /
      table='Color',
      weight='Count',
      displayOut={names={'Table2.OneWayFreqs'='myTable2'}},
      tabulate={'Region', 'Eyes', 'Hair'};
run;

  proc print data=mycas.myTable2;
  run;

proc cas;
   action freqTab.freqTab /
      table={name='Color', groupBy='Region'},
      weight='Count',
      display={names={'NObs', 'OneWayFreqs'}, traceNames=true},
      tabulate={'Eyes', 'Hair'};
run;

   action freqTab.freqTab result=myResult /
      table='Color',
      weight='Count',
      tabulate={'Eyes', 'Hair', {vars={'Region', 'Eyes', 'Hair'}}};
run;

   print myResult;
run;

   print myResult['Table1of3.CrossList']
         myResult['Table2of3.CrossList'];
run;

    describe myResult;
run;

