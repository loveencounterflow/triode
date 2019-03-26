
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
    #.......................................................................................................
    by_length_asc = ( a, b ) ->
      return -1 if a.length < b.length
      return +1 if a.length > b.length
      return -1 if a        < b
      return +1 if a        > b
      return  0
    #.......................................................................................................
    by_length_desc = ( a, b ) ->
      return -1 if a.length > b.length
      return +1 if a.length < b.length
      return -1 if a        < b
      return +1 if a        > b
      return  0
    #.......................................................................................................
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
        throw new Error "µ57633 expected a text or a boolean, got a #{CND.type_of do_sort}"
    #.......................................................................................................
    @find = ( prefix ) =>
      R = trie.find prefix
      R.sort sort_method if sort_method?
      return R
    #.......................................................................................................
    @get_keys_sorted_by_length_asc  = -> [ @keys()..., ].sort by_length_asc
    @get_keys_sorted_by_length_desc = -> [ @keys()..., ].sort by_length_desc
    #.......................................................................................................
    @get_longer_keys = ( key ) ->
      unless ( type = CND.type_of key  ) is 'text'
        throw new Error "µ57954 expected a text, got a #{type}"
      if not @has key
        throw new Error "µ58275 unknown key #{rpr key}"
      R = @get_keys_sorted_by_length_asc()
      for idx in [ 0 ... R.length ]
        break if R[ idx ].length > key.length
      return R[ idx .. ]
    #.......................................................................................................
    @superkeys_from_key = ( key ) ->
      unless ( type = CND.type_of key  ) is 'text'
        throw new Error "µ58596 expected a text, got a #{type}"
      if not @has key
        throw new Error "µ58917 unknown key #{rpr key}"
      return ( sp for sp in @get_longer_keys key when sp.startsWith key )
    #.......................................................................................................
    @get_all_superkeys = ->
      R = {}
      for key from @keys()
        R[ key ] = superprefixes if ( superprefixes = @superkeys_from_key key ).length > 0
      return R
    #.......................................................................................................
    ### TAINT use more efficient method ###
    @has_superkeys = -> ( Object.keys @get_all_superkeys() ).length > 0
    #.......................................................................................................
    @disambiguate_subkey = ( old_key, new_key ) ->
      unless ( type = CND.type_of old_key  ) is 'text'
        throw new Error "µ59238 expected a text, got a #{type}"
      #.....................................................................................................
      unless ( type = CND.type_of new_key ) is 'text'
        throw new Error "µ59559 expected a text, got a #{type}"
      #.....................................................................................................
      if ( @superkeys_from_key old_key ).length is 0
        throw new Error "µ59880 old key #{rpr old_key} is not ambiguous"
      #.....................................................................................................
      if @has new_key
        throw new Error "µ60201 new key #{rpr new_key} already in use"
      @replace old_key, new_key
      #.....................................................................................................
      if ( @superkeys_from_key new_key ).length isnt 0
        throw new Error "µ60522 new key #{rpr new_key} is still ambiguous"
      return null
    #.......................................................................................................
    @apply_replacements_recursively = ( key ) ->
      unless ( type = CND.type_of key  ) is 'text'
        throw new Error "µ60843 expected a text, got a #{type}"
      #.....................................................................................................
      if ( superkeys = @superkeys_from_key key ).length is 0
        throw new Error "µ61164 key #{rpr key} is not ambiguous"
      #.....................................................................................................
      replacement = @get key
      #.....................................................................................................
      for old_superkey in superkeys
        new_superkey = replacement + old_superkey[ key.length ... ]
        @replace old_superkey, new_superkey
      return null
    #.......................................................................................................
    @replace = ( old_key, new_key ) ->
      #.....................................................................................................
      if not @has old_key
        throw new Error "µ61485 unknown old key #{rpr old_key}"
      #.....................................................................................................
      if @has new_key
        throw new Error "µ61806 new key #{rpr new_key} already in use"
      #.....................................................................................................
      value = @get old_key
      @delete old_key
      @set new_key, value
      return null
    #.......................................................................................................
    @replacements_as_js_function_text = ( name ) ->
      if ( subkeys = Object.keys @get_all_superkeys() ).length > 0
        throw new Error "µ61806 must first resolve subkeys #{rpr subkeys}"
      #.....................................................................................................
      R = []
      R.push "( text ) => {"
      R.push "  R = text"
      for key in @get_keys_sorted_by_length_desc()
        replacement = @get key
        R.push "  R = R.replace( /#{CND.escape_regex key}$/, #{rpr replacement} );"
      R.push "  return R; };\n"
      return R.join '\n'
    #.......................................................................................................
    @replacements_as_js_function = ( name ) -> eval @replacements_as_js_function_text name
    #.......................................................................................................
    @replacements_as_js_module_text = ( name ) ->
      source      = @replacements_as_js_function_text name
      { first_line
        source }  = ( source.match /^(?<first_line>[^\n]+)\n(?<source>.*)$/ms ).groups
      R = []
      R.push "// Generated code, do not edit;"
      R.push "// edit #{rpr name} instead and re-generate."
      R.push ""
      R.push "module.exports = #{first_line}"
      R.push source
      R.concat source
      return R.join '\n'
    #.......................................................................................................
    return @
  #.........................................................................................................
  trie = new TrieMap()
  return f.apply Object.create trie


