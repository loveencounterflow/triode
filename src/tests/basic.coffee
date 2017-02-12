
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
TAP.test "incipient", ( T ) ->
  words = [
    '33333333'
    '306ca2f7994a35eef-460-jpg'
    '00d59e245c257deb6-445-jpg'
    ]

  triode = TRIODE.new()
  for word, idx in words
    triode[ word ] = { word, idx, }

  try
    info '1', triode[ '3' ]
  catch error then warn error[ 'message' ]
  T.ok CND.equals triode[ '30' ], { word: '306ca2f7994a35eef-460-jpg', idx: 1 }
  T.ok CND.equals triode[ '00d59' ], { word: '00d59e245c257deb6-445-jpg', idx: 2 }
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

