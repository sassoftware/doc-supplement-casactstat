#***************************************************************/
#          S A S   S A M P L E   L I B R A R Y                 */
#                                                              */
#     NAME: logtype3gs1                                        */
#    TITLE: Example for logisticType3 Action                   */
#     DESC: Binary Logistic Regression                         */
#  PRODUCT: VIYA Statistics                                    */
#   SYSTEM: ALL                                                */
#     KEYS: Logistic regression analysis,                      */
#           Binary response data                               */
#    PROCS: regression action set; logisticType3 action        */
#    DATA:  getStarted data from Example 1 of logistic action  */
# LANGUAGE: Python                                             */
#                                                              */
#  SUPPORT: Bob Derr                                           */
#     MISC:                                                    */
#                                                              */
#***************************************************************/

#****************************************************************
# Binary Logistic Regression
#***************************************************************/

# The data consists of 100 observations on a dichotomous response
# variable y, a character variable C, and 10 continuous variables
# x1--x10.  A main effects binary logistic regression model is fit to
# these data, and the resulting model is stored.  The stored model is
# then used to produce Wald tests of the parameters.

s.upload_file('getStarted.csv')

s.loadactionset(actionset='regression')
m=s.logistic(
   table='getStarted',
   classvars='C',
   model={'depvar':'y',
          'effects':['C', 'x2', 'x8']},
   store={'name':'myModel', 'replace':'true'} )

m=s.logisticType3(
   restore='myModel' )

print(m.ModelAnova)

s.runCode(single='YES',code="\
    data sample;\
       call streamInit(1);\
       do byVar=1 to 2;\
        do i=1 to 10;\
                 if byVar=1 then c=rand('Integer',0,3);\
           else  if byVar=2 then c=rand('Integer',0,1);\
           x=rand('NORMAL');\
           y=1;\
           wgt = 1;\
           if i=5 and byVar=2 then frq  = -1; else frq=1;\
           index + 1;\
           output;\
        end;\
       end;\
 run;"
)

s.loadactionset(actionset='regression')

s.regression.modelMatrix(
   table='sample',
   classVars=['c'],
   model={ 'depVar':'y',
           'effects':['c','x']
         },
   outDesign={'casOut':'designMat',
              'prefix':'param'
             }
)

s.modelMatrix(
   table='sample',
   classVars=['c'],
   model={ 'depVar':'y',
           'effects':['c','x']
         },
   outDesign={'casOut':{'name':'designMat',
                        'replace':True
                       },
              'prefix':'param'
             }
)

s.modelMatrix(
   table='sample',
   classVars='/c/',
   model={ 'depVar':'y',
           'effects':['/c/','x']
         },
   outDesign={'casOut':{'name':'designMat',
                        'replace':True
                       },
              'prefix':'param'
             }
)

myResult = s.modelMatrix(
   table='sample',
   classVars='/c/',
   model={ 'depVar':'y',
           'effects':['/c/','x']
         },
   outDesign={'casOut':{'name':'designMat',
                        'replace':True
                       },
              'prefix':'param'
             }
)

print(myResult)

print(myResult.OutDesignInfo)
print(myResult.ModelInfo)
print(myResult.NObs)
print(myResult.Dimensions)
print(myResult.ClassInfo)

 print("Severity code:", myResult.severity)
 print("Reason:       ", myResult.reason)
 print("Status:       ", myResult.status)

myResult=s.modelMatrix(
   table={'name':'sample','groupBy':'byVar'},
   classVars=['c'],
   spline={'name':{'name':'spl','vars':'x'}},
   model={ 'depVar':'y',
           'effects':['x', '/c/','spl',
                      { 'vars':{'x','c'},'interact':'CROSS'}]
         },
    display={'names':{'/NObs/'}},
    outputTables={'names':{'NObs':'myNObs',
                  'Dimensions':'myDimensions'}
                 },
    freq='frq',
    weight='wgt',
    outDesign={'casOut':{'name':'designMat',
                         'replace':True
                        },
               'prefix':'param'
              }
)

 s.tableInfo(table='designMat')

