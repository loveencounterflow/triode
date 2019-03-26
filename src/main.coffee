
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
TrieMap                   = require 'mnemonist/trie-map'


#-----------------------------------------------------------------------------------------------------------
@new = ( settings ) ->
  trie      = new TrieMap()
  do_sort   = null
  if ( do_sort = settings?.sort )?
    if do_sort is false
      null
    else if do_sort is true
      sort_method = ( a, b ) ->
        return -1 if a[ 0 ] < b[ 0 ]
        return +1 if a[ 0 ] > b[ 0 ]
        return 0
    else if ( CND.isa_text do_sort )
      sort_method = ( a, b ) ->
        return -1 if a[ 1 ][ do_sort ] < b[ 1 ][ do_sort ]
        return +1 if a[ 1 ][ do_sort ] > b[ 1 ][ do_sort ]
        return 0
    else
      throw new Error "µ39833 expected a text or a boolean, got a #{CND.type_of do_sort}"
  #.........................................................................................................
  find = ( prefix ) =>
    R = trie.find prefix
    R.sort sort_method if sort_method?
    return R
  #.........................................................................................................
  set     = ( key, value ) -> trie.set key, value
  delete_ = ( key        ) -> trie.delete key
  #.........................................................................................................
  return { find, set, delete: delete_, }


