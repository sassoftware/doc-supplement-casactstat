#S A S   S A M P L E   L I B R A R Y
#
#    NAME: bartprobitex1
#   TITLE: Example 1 for bartProbit action
# PRODUCT: VIYA Statistics
#    KEYS: BART
#   PROCS: bart action set, bartProbit action
#    DATA:
#    MISC:



s.loadactionset(actionset='bart')

s.bart.bartprobit(
    inputs=['Make', 'Address', 'All', '_3d', 'Our', 'Over', 'Remove',
      'Internet',
            'Order', 'Mail', 'Receive', 'Will', 'People', 'Report', 'Addresses',
            'Free', 'Business', 'Email', 'You', 'Credit', 'Your', 'Font',
            '_000', 'Money', 'HP', 'HPL', 'George', '_650', 'Lab', 'Labs',
            'Telnet', '_857', 'Data', '_415', '_85', 'Technology', '_1999',
            'Parts', 'PM', 'Direct', 'Conference', 'Semicolon', 'Paren',
            'Bracket', 'Exclamation', 'Dollar', 'Pound', 'CapAvg', 'CapLong',
            'CapTotal', 'CS', 'Meeting', 'Original', 'Project', 'RE', 'Edu',
            'Table'],
    nominals='Class',
    partByVar=dict(name='Test', test='1', train='0'),
    seed='210124',
    table='junkmail',
    target='Class')

