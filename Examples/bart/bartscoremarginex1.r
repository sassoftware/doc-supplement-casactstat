#S A S   S A M P L E   L I B R A R Y
#
#    NAME: bartscoreex1
#   TITLE: Example 1 for bartScoreMargin action
# PRODUCT: VIYA Statistics
#    KEYS: BART
#   PROCS: bart action set, bartScoreMargin action
#    DATA:
#    MISC:
#
#Uses the modelFit store created in bartgaussex1 and testData data
#table created in bartscoreex1 to compute predictive margins.


cas.bart.bartScoreMargin(s,
    differences=list(list(evtMargin='x1Evt1',
                          label='x1:0.5 - 0.25',
                          refMargin='x1Ref'),
                     list(evtMargin='x1Evt2', label='x1:0.75 - 0.25',
                          refMargin='x1Ref')),
    marginInfo='true',
    margins=list(list(at=list(list(value='0.25', var='x2')),
                      name='Scenario1'),
                 list(at=list(list(value='0.25', var='x2'),
                              list(value='0.5', var='x3')),
                      name='Scenario2'),
                 list(at=list(list(value='0.25', var='x1')),
                      name='x1Ref'),
                 list(at=list(list(value='0.5', var='x1')),
                      name='x1Evt1'),
                 list(at=list(list(value='0.75', var='x1')),
                      name='x1Evt2')),
    restore='modelFit',
    table='testData')

