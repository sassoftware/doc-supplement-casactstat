/*****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                  */
/*                                                               */
/*     NAME: mvoutlierex1                                        */
/*    TITLE: Assessing Outliers and Leverage in Car Measurements */
/*  PRODUCT: VIYA Statistics                                     */
/*   SYSTEM: ALL                                                 */
/*     KEYS: Robust Multivariate Outlier Detection               */
/*    PROCS: mvOutlier action set; mvOutlier action              */
/*     DATA:                                                     */
/* LANGUAGE: PROC CAS                                            */
/*                                                               */
/*     MISC:                                                     */
/*                                                               */
/*****************************************************************/

data mycas.cars;
   format MakeModel $char20.;
   input MakeModel Length Wheelbase Width Height FrontHd RearHd /
         FrtLegRoom RearSeating FrtShld RearShld Luggage;
   datalines;
AcuraIntegra          -0.2222222     0  -0.5  -2.5   0  -0.5
 0  -0.6666667     -1     -1     1
DodgeColt             -2.2222222  -1.6    -1     0  -1     0
-2          -2   -0.5  -0.75    -1
DodgeOmni             -1.7777778  -0.6  -0.5     1  -1  -1.5
-1          -1  -1.75   -1.5   0.5
EagleSummit                   -1    -1    -1  -0.5   2     0
-1           0  -0.75  -0.75    -2
FordEscort            -1.1111111  -1.6    -1   1.5   0    -1
-1  -0.6666667  -1.75  -1.25     2
FordFestiva           -4.2222222  -2.4  -2.5     2   1     1
-2          -1   -1.5   -1.5    -1
GEOMetro              -3.2222222  -1.8  -2.5  -1.5  -2  -0.5
-1           0  -2.25     -2    -2
GEOPrizm              -0.8888889  -1.2  -1.5  -0.5   0    -1
-2  -1.3333333     -1  -0.75  -1.5
HondaCivic            -1.1111111  -0.8  -0.5    -2   0   0.5
-1           0  -0.75   -0.5    -1
HyundaiExcel          -1.2222222  -1.6  -2.5     0  -2  -0.5
-1          -1   -1.5  -1.25  -1.5
Mazda323              -1.6666667    -1    -1  -0.5   1   0.5
 0  -0.3333333   -1.5     -1  -0.5
MazdaProtege          -0.7777778  -0.8    -1    -1   1   0.5
-2  -0.6666667   -0.5      0  -0.5
MercuryTracer         -1.8888889  -1.4  -1.5    -1   0     0
-2  -0.3333333   -1.5     -1   0.5
MitsubishiPrecis              -2  -1.6  -2.5     0   1     1
-3  -0.6666667   -1.5  -0.75  -1.5
NissanSentra          -0.7777778  -1.2  -1.5    -1  -1     0
-3          -2  -1.25  -0.75    -1
PontiacLeMans         -0.7777778  -0.6    -1     0   3   0.5
 0  -1.3333333  -0.75   -0.5     2
SubaruJusty           -3.6666667  -2.4    -4   0.5  -2  -1.5
-2  -2.6666667     -2  -1.75  -2.5
SubaruLoyale          -0.4444444    -1  -1.5    -1  -2     0
-1           0  -0.75  -0.25   0.5
ToyotaCorolla                 -1  -1.2  -1.5  -0.5   1     0
-2          -1     -1  -0.75  -1.5
ToyotaTercel          -1.3333333  -1.6    -2  -0.5  -1  -0.5
-2  -1.6666667     -1  -0.75  -0.5
VolkswagenFox         -1.7777778  -1.8  -2.5  -0.5  -1     0
 1          -1  -1.75   -1.5    -2
VolkswagenGolf        -2.3333333    -1    -1     1  -1     0
-1  -0.3333333     -1   -0.5     2
VolkswagenJetta       -0.7777778    -1    -1     1   0   0.5
-1   0.3333333     -1  -0.25   1.5
ChevroletCamaro        1.4444444  -0.2   2.5  -3.5   0  -1.5
 0  -2.3333333    1.5   0.75    -1
ChevroletCorvette     -0.2222222  -1.2   1.5  -6.5  -3    -4
 1 -19.6666667   -0.5    -28    -8
DodgeDaytona                   0    -1   0.5    -3  -1    -2
-1  -3.3333333    0.5      0   1.5
FordMustang            0.1111111  -0.2     0    -1   0  -1.5
-1  -2.3333333   0.25   0.25    -1
FordProbe             -0.2222222  -0.6     0    -3  -1    -2
 0  -2.6666667  -0.25     -1    -1
GEOStorm              -1.7777778    -1  -0.5  -3.5  -1    -2
 0          -2     -2  -3.25  -1.5
HondaCivicCRX         -3.3333333  -2.2    -1    -5  -4    -4
 2 -19.6666667     -1    -28    -8
HondaPrelude          -0.1111111  -0.2  -0.5    -3  -4    -2
 2  -2.6666667  -1.25  -1.75  -1.5
MazdaMX5Miata         -2.6666667  -2.6    -1  -6.5   0    -4
-2 -19.6666667  -2.25    -28    -8
MazdaMX6              -0.2222222  -0.6  -0.5  -1.5  -3     0
 0          -1      0  -0.75   0.5
MazdaRX7                      -1  -1.2  -0.5  -4.5  -4    -4
 1 -19.6666667     -1    -28    -8
Nissan240SX           -0.1111111    -1  -0.5  -3.5  -1    -2
-1          -4  -0.75  -1.75     0
Nissan300ZX                   -1    -1   1.5    -5  -1    -4
 1 -19.6666667   0.75    -28    -8
NissanPulsarNX        -1.3333333  -1.2    -1    -4   1    -2
-1  -4.3333333   -1.5  -2.25  -3.5
PlymouthLaser         -0.8888889    -1  -0.5    -3   0    -2
 0          -3   -0.5     -1    -2
Porsche944            -1.1111111  -1.4     0    -4   0    -2
 4  -6.3333333   0.25  -1.25    -1
SubaruXT              -0.1111111    -1  -0.5    -4  -3    -2
 1  -3.3333333     -1   -1.5    -2
ToyotaCelica          -0.5555556  -0.6   0.5    -3  -3    -2
 1          -3  -1.75     -3  -0.5
ToyotaSupra            0.3333333     0   0.5  -3.5  -2    -2
 2          -3  -1.25  -1.75  -1.5
VolkswagenCorrado     -2.2222222    -1    -1    -3  -3    -2
 1          -1  -0.75   -1.5   2.5
VolkswagenGTI         -2.3333333    -1    -1   0.5   0     0
 0  -0.3333333     -1      0     2
Audi80                -0.3333333  -0.4  -0.5   0.5   1    -1
 1   0.3333333  -1.25     -1    -2
BMW325i               -0.4444444  -0.2  -1.5  -0.5  -3    -1
 1  -1.3333333   -1.5  -1.25    -1
ChevroletBeretta       0.8888889   0.2     0    -1   0  -1.5
 1           0   0.25    0.5     0
ChevroletCavalier              0  -0.2    -1     0   1     1
-1  -0.6666667  -0.75  -0.25     0
ChevroletCorsica       0.4444444   0.2     0     1   1     1
 0  -0.6666667  -0.25    0.5     0
ChryslerLeBaron        0.4444444   0.2     0     1   1   0.5
-1           2   -0.5  -0.25     0
DodgeShadow           -0.7777778    -1  -0.5     1   1   0.5
 0  -1.6666667  -0.25  -0.25  -0.5
DodgeSpirit            0.2222222   0.2  -0.5     1   0     1
-1           2   -0.5   0.25     0
FordTempo             -0.2222222  -0.4     0  -0.5   0  -0.5
-1           0     -1      0  -0.5
HondaAccord            0.6666667     1     0  -0.5   2     0
 1  -0.3333333  -0.25      0     0
Mazda626                       0  -0.2  -0.5  -0.5   0     0
-2  -0.3333333      0    0.5   0.5
Mercedes-Benz190      -0.4444444   0.6  -0.5   0.5  -3  -1.5
 5          -1  -0.75   -0.5    -1
MitsubishiGalant       0.5555556     0  -0.5   0.5   1   0.5
-1   1.3333333      0    0.5  -1.5
MitsubishiSigma        0.7777778     0  -0.5  -0.5  -4  -0.5
-3   0.3333333  -0.75   -0.5    -1
NissanStanza           0.1111111  -0.4  -0.5  -0.5   0     0
-2  -0.6666667      0      0     0
Peugeot405            -0.4444444   0.6     0     1   1  -0.5
-1           1   0.25    0.5     0
PontiacGrandAm         0.1111111   0.2  -0.5  -1.5   0    -1
 0  -0.6666667      0      0  -0.5
Saab900                0.5555556  -0.6  -0.5   0.5   0     0
 0           0     -1   -0.5     0
SubaruLegacy          -0.1111111     0  -0.5    -1  -3     0
-1           0   -0.5  -0.25     0
ToyotaCamry            0.3333333     0  -0.5   0.5  -1     0
 1   0.6666667  -0.25  -0.25    -1
Volvo240               1.2222222   0.4  -0.5   2.5   0     0
 0   1.3333333   -0.5   -0.5     0
AcuraLegend            1.3333333   1.4   0.5     0  -3     0
 0   0.6666667   0.25   0.75     0
Audi100                1.5555556   0.8   1.5   1.5  -2     1
 0   2.3333333   0.75    0.5   1.5
BMW535i                0.7777778   1.4   0.5     1  -1   0.5
 1  -0.3333333  -0.25   0.75    -1
BuickCentury           1.1111111   0.6   0.5  -0.5   1   0.5
 1   0.3333333   0.75      1     1
BuickRegal             1.4444444   1.2   1.5   0.5   4   1.5
-1           0    1.5   1.25   0.5
BuickRiviera           2.1111111   1.2   2.5  -1.5   0     0
 0  -0.6666667    1.5   1.25     0
CadillacEldorado       1.3333333   1.2     2    -1  -1     0
 1   0.3333333    1.5    1.5     0
CadillacSeville        1.3333333   1.2     2    -1  -1     0
 1           1   1.25   1.25     0
ChevroletLumina        2.1111111   1.2   1.5     1   2   1.5
 1   1.6666667   1.75   1.25   0.5
ChryslerImperial       2.6666667   1.4   0.5     1   1  -0.5
 1   2.6666667    0.5   0.75   1.5
ChryslerLeBaronCoupe   0.6666667  -0.4   0.5    -1   0  -1.5
 0          -1    0.5    0.5     0
DodgeDynasty           1.4444444   0.4   0.5     1   1  -0.5
-1   2.3333333    0.5   0.75     1
EaglePremier           1.5555556   0.8     1     1   0     0
 1   1.6666667   1.25   1.25   1.5
FordTaurus                     1   0.8   1.5   0.5   1     0
 1           1   1.25   1.75   1.5
FordThunderbird        2.2222222   2.2   2.5    -1   0  -1.5
 0   0.3333333      2   2.75   0.5
HyundaiSonata          0.5555556   0.4   0.5   0.5   0   0.5
-1   2.3333333      1   1.25     0
InfinitiQ45            2.3333333   2.2     2   0.5  -2  -0.5
 0   1.3333333   1.25    1.5   0.5
LexusLS400                     2   1.8     2   0.5  -1     0
 3           1      1      1     0
LincolnContinental     2.8888889   1.4   2.5   0.5   1     1
-1   1.3333333   1.25   1.75   2.5
LincolnMarkVII         2.6666667   1.4   1.5    -1  -1  -1.5
 1   0.6666667    0.5   1.75     0
Mazda929               1.6666667     1     0     1  -1   0.5
 0           1   0.25   0.75   0.5
MercedesBenz300E       0.8888889   1.6   0.5     2  -1  -0.5
 2  -0.3333333    0.5      1   0.5
NissanMaxima                   1   0.4   0.5  -0.5  -3  -0.5
 0           1   0.75   0.75     0
Peugeot505             0.2222222   1.2     0     2  -2    -1
 1   1.3333333   0.25   0.25  -1.5
Saab9000                       1   0.6   0.5     2  -2   0.5
 1   2.3333333      1    1.5     2
Sterling827            1.1111111   1.4     0     0  -3  -0.5
 1   1.3333333      0      0    -1
ToyotaCressida         1.2222222   0.8  -0.5   0.5  -3  -0.5
-1           0      0   0.25    -1
Volvo740                       1   1.4   0.5   0.5  -2     1
 1   1.3333333   0.75   1.25   1.5
BuickElectra                   2   1.8     2   0.5   5   2.5
 1           2   1.75   2.25     1
BuickLeSabre                   2   1.8     2     1   3   1.5
-1   0.6666667      2   2.25     1
CadillacBrougham       4.6666667     4   4.5   2.5   3   1.5
 3           3   2.75      3   2.5
CadillacDeVille                3   2.4   2.5     1   5     2
 1   1.6666667   2.25   2.25     1
ChevroletCaprice       3.6666667   2.8   3.5   2.5   3   0.5
-1   0.3333333      3    3.5     3
FordLTDCrownVictor     3.5555556   2.4     5     2   0     0
 0           1   3.25   3.75     4
LincolnTownCar         4.5555556     3     5     3   2     1
-1   2.6666667    3.5      4     4
PontiacBonneville      2.2222222   1.8     2   0.5   1     2
 1   1.3333333      2    2.5   0.5
ChevroletAstro        -0.2222222   1.8   4.5  18.5   3   2.5
 1   0.3333333   3.25  -1.75    -8
ChevroletLuminaAPV     1.6666667   1.6     3    10   2     2
-1   3.3333333   2.75      4    -8
DodgeCaravan          -0.3333333     2     2  10.5   2   2.5
 0  -0.3333333   1.75  -6.25    -8
DodgeGrandCaravan      1.3333333   3.4     2    11   1     2
-2   2.3333333    1.5   3.25    -8
FordAerostar          -0.4444444   3.4     2  16.5   3   1.5
 1   1.6666667    2.5   4.25    -8
MazdaMPV              -0.3333333   1.6     2  11.5   3   3.5
-1           0   1.25   -5.5    -8
MitsubishiWagon       -0.4444444  -2.8  -0.5  15.5   1   2.5
-2         -19   0.75    2.5    -8
NissanAxxess          -0.7777778   0.2  -0.5     8   1   2.5
-2   0.6666667   0.25   1.25  -8.5
NissanVan             -0.1111111  -1.8  -0.5  15.5   0     3
-1         -19      1   2.25    -8
VolkswagenVanagon      0.1111111    -1   2.5  20.5   3     7
-5   6.3333333   3.25  -7.25    -8
 ;

proc cas;
   action mvOutlier.mvOutlier / table={name="cars"},
   model={effects={"Length","Wheelbase","Width","Height","FrontHd","RearHd",
      "FrtLegRoom","RearSeating","FrtShld","RearShld","Luggage"}},
   id="MakeModel", initOnly=TRUE;
run;

proc cas;
   action mvOutlier.mvOutlier / table={name="cars"},
   model={effects={"Length","Wheelbase","Width","Height","FrontHd","RearHd",
      "FrtLegRoom","RearSeating","FrtShld","RearShld","Luggage"}},
   id="MakeModel", propVariance=0.9,
   display={names={"NVars","EigenvaluesFinal","Cutoffs",
                   "DiagSummary","Diagnostics"}};
run;

