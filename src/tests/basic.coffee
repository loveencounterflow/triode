
############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr
badge                     = 'TRIODE/TESTS/basic'
debug                     = CND.get_logger 'debug',     badge
urge                      = CND.get_logger 'urge',      badge
info                      = CND.get_logger 'info',      badge
help                      = CND.get_logger 'help',      badge
warn                      = CND.get_logger 'warn',      badge
echo                      = CND.echo.bind CND
#...........................................................................................................
TAP                       = require 'tap'
TRIODE                    = require '../..'


#-----------------------------------------------------------------------------------------------------------
TAP.test "demo", ( T ) ->
  TRIODE = require '../..'
  triode = TRIODE.new()
  triode[ 'aluminum'    ] = { word: 'aluminum', text: 'a metal', }
  triode[ 'aluminium'   ] = { word: 'aluminium', text: 'a metal', }
  triode[ 'alumni'      ] = { word: 'alumni', text: 'a former student', }
  triode[ 'alphabet'    ] = { word: 'alphabet', text: 'a kind of writing system', }
  triode[ 'abacus'      ] = { word: 'abacus', text: 'a manual calculator', }

  try
    triode[ 'alu' ]
  catch error
    ### unspecific prefix 'a' ###
    warn error[ 'message' ]

  ### { word: 'alumni', text: 'a former student' } ###
  info triode[ 'alumn' ]

  ### { word: 'alphabet', text: 'a kind of writing system' } ###
  info triode[ 'alp' ]

  delete triode[ 'alp' ]
  ### undefined ###
  info triode[ 'alp' ]

  T.end()

#-----------------------------------------------------------------------------------------------------------
TAP.test "incipient", ( T ) ->
  words = [
    '33333333'
    '306ca2f7994a35eef-460-jpg'
    '00d59e245c257deb6-445-jpg'
    '12345678'
    ]

  triode = TRIODE.new()
  for word, idx in words
    triode[ word ] = { word, idx, }

  try
    info '1', triode[ '3' ]
  catch error then warn error[ 'message' ]
  T.ok CND.equals triode[ '30' ], { word: '306ca2f7994a35eef-460-jpg', idx: 1 }
  T.ok CND.equals triode[ '00d59' ], { word: '00d59e245c257deb6-445-jpg', idx: 2 }
  T.ok CND.equals triode[ '123' ], { word: '12345678', idx: 3 }
  T.ok CND.equals triode[ 'ffffffff' ], undefined
  delete triode[ '00d59' ]
  help triode
  info '5', triode[ '00d59' ]
  T.ok CND.equals triode[ '00d' ], undefined
  try
    delete triode[ '3' ]
  catch error then warn error[ 'message' ]
  help triode
  T.end()

