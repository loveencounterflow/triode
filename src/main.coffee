
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
  f = ->
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
        throw new Error "µ12345 expected a text or a boolean, got a #{CND.type_of do_sort}"
    #.......................................................................................................
    @find = ( prefix ) =>
      R = trie.find prefix
      R.sort sort_method if sort_method?
      return R
    #.......................................................................................................
    @get_keys_sorted_by_length = ->
      return [ @keys()..., ].sort ( a, b ) ->
        return -1 if a.length < b.length
        return +1 if a.length > b.length
        return  0
    #.......................................................................................................
    @get_longer_keys = ( key ) ->
      unless ( type = CND.type_of key  ) is 'text'
        throw new Error "µ12346 expected a text, got a #{type}"
      if not @has key
        throw new Error "µ12349 unknown key #{rpr key}"
      R = @get_keys_sorted_by_length()
      for idx in [ 0 ... R.length ]
        break if R[ idx ].length > key.length
      return R[ idx .. ]
    #.......................................................................................................
    @superkeys_from_key = ( key ) ->
      unless ( type = CND.type_of key  ) is 'text'
        throw new Error "µ12346 expected a text, got a #{type}"
      if not @has key
        throw new Error "µ12349 unknown key #{rpr key}"
      return ( sp for sp in @get_longer_keys key when sp.startsWith key )
    #.......................................................................................................
    @get_all_superkeys = ->
      R = {}
      for key from @keys()
        R[ key ] = superprefixes if ( superprefixes = @superkeys_from_key key ).length > 0
      return R
    #.......................................................................................................
    @disambiguate_subkey = ( old_key, new_key ) ->
      unless ( type = CND.type_of old_key  ) is 'text'
        throw new Error "µ12346 expected a text, got a #{type}"
      #.....................................................................................................
      unless ( type = CND.type_of new_key ) is 'text'
        throw new Error "µ12347 expected a text, got a #{type}"
      #.....................................................................................................
      if ( @superkeys_from_key old_key ).length is 0
        throw new Error "µ12348 old key #{rpr old_key} is not ambiguous"
      #.....................................................................................................
      if @has new_key
        throw new Error "µ12349 new key #{rpr new_key} already in use"
      @replace old_key, new_key
      #.....................................................................................................
      if ( @superkeys_from_key new_key ).length isnt 0
        throw new Error "µ12350 new key #{rpr new_key} is still ambiguous"
      return null
    #.......................................................................................................
    @replace = ( old_key, new_key ) ->
      #.....................................................................................................
      if not @has old_key
        throw new Error "µ12349 unknown old key #{rpr old_key}"
      #.....................................................................................................
      if @has new_key
        throw new Error "µ12349 new key #{rpr new_key} already in use"
      #.....................................................................................................
      value = @get old_key
      @delete old_key
      @set new_key, value
      return null
    #.......................................................................................................
    return @
  #.........................................................................................................
  trie = new TrieMap()
  return f.apply Object.create trie


