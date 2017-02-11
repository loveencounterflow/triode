
############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr
badge                     = 'TRIODE'
debug                     = CND.get_logger 'debug',     badge
urge                      = CND.get_logger 'urge',      badge
info                      = CND.get_logger 'info',      badge
help                      = CND.get_logger 'help',      badge
warn                      = CND.get_logger 'warn',      badge
echo                      = CND.echo.bind CND
#...........................................................................................................
MNEMONIST                 = require 'mnemonist'
Σ_missing                 = Symbol 'missing'
# Trie                      = require 'mnemonist/trie'


#-----------------------------------------------------------------------------------------------------------
@new = ->
  trie  = new MNEMONIST.Trie()
  store = {}
  #.........................................................................................................
  resolve = ( prefix ) ->
    keys = trie.get prefix
    return Σ_missing if keys.length is 0
    throw new Error "unspecific prefix #{rpr prefix}" if keys.length isnt 1
    return keys[ 0 ]
  #.........................................................................................................
  set = ( _, key, value ) =>
    trie.add key
    return store[ key ] = value
  #.........................................................................................................
  get = ( _, prefix ) => store[ resolve prefix ]
  #.........................................................................................................
  deleteProperty = ( _, prefix ) -> delete store[ resolve prefix ]
  #.........................................................................................................
  return new Proxy store, { get, set, deleteProperty, }

words = [
  '33333333'
  '306ca2f7994a35eef-460-jpg'
  '00d59e245c257deb6-445-jpg'
  ]

r = @new()
for word, idx in words
  r[ word ] = { word, idx, }

try
  info '1', r[ '3' ]
catch error then warn error[ 'message' ]
info '2', r[ '30' ]
info '3', r[ '00d59' ]
info '4', r[ 'ffffffff' ]
delete r[ '00d59' ]
help r
info '5', r[ '00d59' ]
try
  delete r[ '3' ]
catch error then warn error[ 'message' ]
help r
info '6', r[ '00d59' ]


