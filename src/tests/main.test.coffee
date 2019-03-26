
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
jr                        = JSON.stringify
test                      = require 'guy-test'
TRIODE                    = require '../..'


#-----------------------------------------------------------------------------------------------------------
@[ "basic" ] = ( T, done ) ->
  triode = TRIODE.new()
  triode.set 'aluminum',  { word: 'aluminum', text: 'a metal', }
  triode.set 'aluminium', { word: 'aluminium', text: 'a metal', }
  triode.set 'alumni',    { word: 'alumni', text: 'a former student', }
  triode.set 'alphabet',  { word: 'alphabet', text: 'a kind of writing system', }
  triode.set 'abacus',    { word: 'abacus', text: 'a manual calculator', }
  #.........................................................................................................
  probes_and_matchers = [
    ["a",[["abacus",{"word":"abacus","text":"a manual calculator"}],["alphabet",{"word":"alphabet","text":"a kind of writing system"}],["alumni",{"word":"alumni","text":"a former student"}],["aluminium",{"word":"aluminium","text":"a metal"}],["aluminum",{"word":"aluminum","text":"a metal"}]],null]
    ["alu",[["alumni",{"word":"alumni","text":"a former student"}],["aluminium",{"word":"aluminium","text":"a metal"}],["aluminum",{"word":"aluminum","text":"a metal"}]],null]
    ["alp",[["alphabet",{"word":"alphabet","text":"a kind of writing system"}]],null]
    ["b",[],null]
    ]
  #.........................................................................................................
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
      result = triode.find probe
      # urge jr [ probe, result, null, ]
      resolve result
      return null
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "sorting 1" ] = ( T, done ) ->
  triode = TRIODE.new { sort: 'text', }
  triode.set 'aluminum',  { word: 'aluminum', text: '05 a metal', }
  triode.set 'aluminium', { word: 'aluminium', text: '04 a metal', }
  triode.set 'alumni',    { word: 'alumni', text: '02 a former student', }
  triode.set 'alphabet',  { word: 'alphabet', text: '03 a kind of writing system', }
  triode.set 'abacus',    { word: 'abacus', text: '01 a manual calculator', }
  #.........................................................................................................
  probes_and_matchers = [
    ["a",[["abacus",{"word":"abacus","text":"01 a manual calculator"}],["alumni",{"word":"alumni","text":"02 a former student"}],["alphabet",{"word":"alphabet","text":"03 a kind of writing system"}],["aluminium",{"word":"aluminium","text":"04 a metal"}],["aluminum",{"word":"aluminum","text":"05 a metal"}]],null]
    ["alu",[["alumni",{"word":"alumni","text":"02 a former student"}],["aluminium",{"word":"aluminium","text":"04 a metal"}],["aluminum",{"word":"aluminum","text":"05 a metal"}]],null]
    ["alp",[["alphabet",{"word":"alphabet","text":"03 a kind of writing system"}]],null]
    ["b",[],null]
    ]
  #.........................................................................................................
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
      result = triode.find probe
      resolve result
      return null
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "sorting 2" ] = ( T, done ) ->
  triode = TRIODE.new { sort: true, }
  triode.set 'aluminum',  { word: 'aluminum', text: '05 a metal', }
  triode.set 'aluminium', { word: 'aluminium', text: '04 a metal', }
  triode.set 'alumni',    { word: 'alumni', text: '02 a former student', }
  triode.set 'alphabet',  { word: 'alphabet', text: '03 a kind of writing system', }
  triode.set 'abacus',    { word: 'abacus', text: '01 a manual calculator', }
  #.........................................................................................................
  probes_and_matchers = [
    ["a",[["abacus",{"word":"abacus","text":"01 a manual calculator"}],["alphabet",{"word":"alphabet","text":"03 a kind of writing system"}],["aluminium",{"word":"aluminium","text":"04 a metal"}],["aluminum",{"word":"aluminum","text":"05 a metal"}],["alumni",{"word":"alumni","text":"02 a former student"}]],null] #! expected result: [["abacus",{"word":"abacus","text":"01 a manual calculator"}],["alumni",{"word":"alumni","text":"02 a former student"}],["alphabet",{"word":"alphabet","text":"03 a kind of writing system"}],["aluminium",{"word":"aluminium","text":"04 a metal"}],["aluminum",{"word":"aluminum","text":"05 a metal"}]]
    ["alu",[["aluminium",{"word":"aluminium","text":"04 a metal"}],["aluminum",{"word":"aluminum","text":"05 a metal"}],["alumni",{"word":"alumni","text":"02 a former student"}]],null] #! expected result: [["alumni",{"word":"alumni","text":"02 a former student"}],["aluminium",{"word":"aluminium","text":"04 a metal"}],["aluminum",{"word":"aluminum","text":"05 a metal"}]]
    ["alp",[["alphabet",{"word":"alphabet","text":"03 a kind of writing system"}]],null]
    ["b",[],null]
    ]
  #.........................................................................................................
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
      result = triode.find probe
      resolve result
      return null
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "prefixes by length" ] = ( T, done ) ->
  triode = TRIODE.new { sort: true, }
  triode.set 'q',   'っ'
  triode.set 'n',   'ん'
  triode.set 'v',   'ゔ'
  triode.set 'va',  'ゔぁ'
  triode.set 'vi',  'ゔぃ'
  triode.set 'vu',  'ゔぅ'
  triode.set 've',  'ゔぇ'
  triode.set 'vo',  'ゔぉ'
  triode.set 'na',  'な'
  triode.set 'ne',  'ね'
  triode.set 'ni',  'に'
  triode.set 'no',  'の'
  triode.set 'nu',  'ぬ'
  triode.set 'ya',  'や'
  triode.set 'yo',  'よ'
  triode.set 'yu',  'ゆ'
  triode.set 'nya', 'にゃ'
  triode.set 'nyo', 'にょ'
  triode.set 'nyu', 'にゅ'
  #.........................................................................................................
  probes_and_matchers = [
    [["get_keys_sorted_by_length_asc",[]],["n","q","v","na","ne","ni","no","nu","va","ve","vi","vo","vu","ya","yo","yu","nya","nyo","nyu"],null]
    [["get_longer_keys",["n"]],["na","ne","ni","no","nu","va","ve","vi","vo","vu","ya","yo","yu","nya","nyo","nyu"],null]
    [["get_longer_keys",["na"]],["nya","nyo","nyu"],null]
    [["superkeys_from_key",["n"]],["na","ne","ni","no","nu","nya","nyo","nyu"],null]
    [["superkeys_from_key",["v"]],["va","ve","vi","vo","vu"],null]
    [["get_all_superkeys",[]],{"v":["va","ve","vi","vo","vu"],"n":["na","ne","ni","no","nu","nya","nyo","nyu"]},null]
    ]
  #.........................................................................................................
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
      [ method_name, P, ] = probe
      result = triode[ method_name ] P...
      resolve result
  #.........................................................................................................
  done()
  return null



#-----------------------------------------------------------------------------------------------------------
@[ "_ demo" ] = ( T, done ) ->
  triode = TRIODE.new { sort: true, }
  triode.set 'q',   'っ'
  triode.set 'n',   'ん'
  triode.set 'v',   'ゔ'
  triode.set 'va',  'ゔぁ'
  triode.set 'vi',  'ゔぃ'
  triode.set 'vu',  'ゔぅ'
  triode.set 've',  'ゔぇ'
  triode.set 'vo',  'ゔぉ'
  triode.set 'na',  'な'
  triode.set 'ne',  'ね'
  triode.set 'ni',  'に'
  triode.set 'no',  'の'
  triode.set 'nu',  'ぬ'
  triode.set 'ya',  'や'
  triode.set 'yo',  'よ'
  triode.set 'yu',  'ゆ'
  triode.set 'nya', 'にゃ'
  triode.set 'nyo', 'にょ'
  triode.set 'nyu', 'にゅ'
  debug 'µ76777-1', triode
  debug 'µ76777-2', triode.get_keys_sorted_by_length_asc()
  debug 'µ76777-3', triode.get_longer_keys 'n'
  # debug 'µ76777-4', triode.get_longer_keys 'na'
  debug 'µ76777-5', triode.superkeys_from_key 'n'
  debug 'µ76777-6', triode.superkeys_from_key 'v'
  debug 'µ76777-7', triode.get_all_superkeys()
  # debug 'µ76777-8', triode.disambiguate_subkey 'n', 'n.'
  debug 'µ76777-9', triode
  # debug 'µ76777-10', triode.superkeys_from_key 'n'
  # debug 'µ76777-11', triode.superkeys_from_key 'n.'
  debug 'µ76777-12', triode.has 'n'
  debug 'µ76777-13', triode.has 'n.'
  # debug 'µ76777-14', triode.disambiguate_subkey 'n.', 'v'
  # debug 'µ76777-15', triode.disambiguate_subkey 'a', 'n.'
  debug 'µ76777-16', triode.disambiguate_subkey 'v', 'v.'
  debug 'µ76777-17', triode.get_all_superkeys()
  # debug 'µ76777-18', triode.apply_replacements_recursively 'v'
  debug 'µ76777-20', triode.apply_replacements_recursively 'n'
  debug 'µ76777-17', triode.has_superkeys()
  urge 'µ76777-21', '\n' + triode.replacements_as_js_module_text 'foobar/kana.wsv'
  replacer = triode.replacements_as_js_function 'foobar/kana.wsv'
  debug 'µ76777-17', replacer 'ka'
  debug 'µ76777-17', replacer 'ki'
  debug 'µ76777-17', replacer 'んa'
  debug 'µ76777-17', replacer 'んe'
  debug 'µ76777-17', replacer 'n'
  debug 'µ76777-17', replacer 'v.'
  debug 'µ76777-17', replacer 'va'
  debug 'µ76777-6', triode.superkeys_from_key 'v.'
  # debug 'µ76777-22', triode
  done()
  return null


############################################################################################################
unless module.parent?
  # test @
  # test @[ "selector keypatterns" ]
  # test @[ "select 2" ]
  test @[ "_ demo" ]



