/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*     NAME: gamselex1                                          */
/*    TITLE: Example for gamSelectl Action                      */
/*     DESC: Boosting Model Selection                           */
/*  PRODUCT: VIYA Statistics                                    */
/*   SYSTEM: ALL                                                */
/*     KEYS: nonparametric regression analysis, boosting        */
/*    PROCS: gam action set; gamSelect action                   */
/*    DATA:                                                     */
/* LANGUAGE: PROC CAS                                           */
/*                                                              */
/*  SUPPORT: Michael Lamm                                       */
/*     MISC:                                                    */
/*                                                              */
/****************************************************************/


data mycas.getStarted;
  drop i j w;

  array x{90};
  call streaminit(4321);
  pi=constant("pi");

  do i=1 to 20000;
      u = ranuni(12345);
      do j=1 to dim(x);
         w    = ranuni(12345);
         x{j} = (w + u)/2;
      end;
      f1 = x1;
      f2 = (2*x2-1)**2;
      f3 = sin(2 * pi * x3)/(2-sin(2*pi*x3));
      f4 = 0.1*sin(2*pi*x4) + 0.2*cos(2*pi*x4)+0.3*sin(2*pi*x4)**2
         + 0.4*cos(2*pi*x4)**3+0.5*sin(2*pi*x4)**3;
      linp = 5*f1+3*f2+4*f3+6*f4;
      y =  linp + 1.32 * rand("Normal");
      output;
   end;
run;

proc cas;
gam.gamSelect
   table='getStarted',seed=12345,
   model={depVar='y',
          splines={'x1', 'x2', 'x3', 'x4', 'x5',
                   'x6', 'x7', 'x8', 'x9', 'x10',
                   'x11', 'x12', 'x13', 'x14', 'x15',
                   'x16', 'x17', 'x18', 'x19', 'x20',
                   'x21', 'x22', 'x23', 'x24', 'x25',
                   'x26', 'x27', 'x28', 'x29', 'x30',
                   'x31', 'x32', 'x33', 'x34', 'x35',
                   'x36', 'x37', 'x38', 'x39', 'x40',
                   'x41', 'x42', 'x43', 'x44', 'x45',
                   'x46', 'x47', 'x48', 'x49', 'x50',
                   'x51', 'x52', 'x53', 'x54', 'x55',
                   'x56', 'x57', 'x58', 'x59', 'x60',
                   'x61', 'x62', 'x63', 'x64', 'x65',
                   'x66', 'x67', 'x68', 'x69', 'x70',
                   'x71', 'x72', 'x73', 'x74', 'x75',
                   'x76', 'x77', 'x78', 'x79', 'x80',
                   'x81', 'x82', 'x83', 'x84', 'x85',
                   'x86', 'x87', 'x88', 'x89', 'x90'}
         },
   selection={method='boosting'};
run;

