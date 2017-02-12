
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


