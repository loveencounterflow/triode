
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
  triode[ 'aluminum'    ] = { word: 'aluminum', text: 'a metal', }
  triode[ 'aluminium'   ] = { word: 'aluminium', text: 'a metal', }
  triode[ 'alumni'      ] = { word: 'alumni', text: 'a former student', }
  triode[ 'alphabet'    ] = { word: 'alphabet', text: 'a kind of writing system', }
  triode[ 'abacus'      ] = { word: 'abacus', text: 'a manual calculator', }
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
      result = triode[ probe ]
      # urge jr [ probe, result, null, ]
      resolve result
      return null
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "sorting 1" ] = ( T, done ) ->
  triode = TRIODE.new { sort: 'text', }
  triode[ 'aluminum'    ] = { word: 'aluminum', text: '05 a metal', }
  triode[ 'aluminium'   ] = { word: 'aluminium', text: '04 a metal', }
  triode[ 'alumni'      ] = { word: 'alumni', text: '02 a former student', }
  triode[ 'alphabet'    ] = { word: 'alphabet', text: '03 a kind of writing system', }
  triode[ 'abacus'      ] = { word: 'abacus', text: '01 a manual calculator', }
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
      result = triode[ probe ]
      resolve result
      return null
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "sorting 2" ] = ( T, done ) ->
  triode = TRIODE.new { sort: true, }
  triode[ 'aluminum'    ] = { word: 'aluminum', text: '05 a metal', }
  triode[ 'aluminium'   ] = { word: 'aluminium', text: '04 a metal', }
  triode[ 'alumni'      ] = { word: 'alumni', text: '02 a former student', }
  triode[ 'alphabet'    ] = { word: 'alphabet', text: '03 a kind of writing system', }
  triode[ 'abacus'      ] = { word: 'abacus', text: '01 a manual calculator', }
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
      result = triode[ probe ]
      resolve result
      return null
  done()
  return null


############################################################################################################
unless module.parent?
  test @
  # test @[ "selector keypatterns" ]
  # test @[ "select 2" ]



