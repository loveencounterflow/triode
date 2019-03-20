// Generated by CoffeeScript 2.3.2
(function() {
  //###########################################################################################################
  var CND, TRIODE, badge, debug, echo, help, info, jr, rpr, test, urge, warn;

  CND = require('cnd');

  rpr = CND.rpr;

  badge = 'TRIODE/TESTS/basic';

  debug = CND.get_logger('debug', badge);

  urge = CND.get_logger('urge', badge);

  info = CND.get_logger('info', badge);

  help = CND.get_logger('help', badge);

  warn = CND.get_logger('warn', badge);

  echo = CND.echo.bind(CND);

  //...........................................................................................................
  jr = JSON.stringify;

  test = require('guy-test');

  TRIODE = require('../..');

  //-----------------------------------------------------------------------------------------------------------
  this["basic"] = async function(T, done) {
    var error, i, len, matcher, probe, probes_and_matchers, triode;
    triode = TRIODE.new();
    triode['aluminum'] = {
      word: 'aluminum',
      text: 'a metal'
    };
    triode['aluminium'] = {
      word: 'aluminium',
      text: 'a metal'
    };
    triode['alumni'] = {
      word: 'alumni',
      text: 'a former student'
    };
    triode['alphabet'] = {
      word: 'alphabet',
      text: 'a kind of writing system'
    };
    triode['abacus'] = {
      word: 'abacus',
      text: 'a manual calculator'
    };
    //.........................................................................................................
    probes_and_matchers = [
      [
        "a",
        [
          [
            "abacus",
            {
              "word": "abacus",
              "text": "a manual calculator"
            }
          ],
          [
            "alphabet",
            {
              "word": "alphabet",
              "text": "a kind of writing system"
            }
          ],
          [
            "alumni",
            {
              "word": "alumni",
              "text": "a former student"
            }
          ],
          [
            "aluminium",
            {
              "word": "aluminium",
              "text": "a metal"
            }
          ],
          [
            "aluminum",
            {
              "word": "aluminum",
              "text": "a metal"
            }
          ]
        ],
        null
      ],
      [
        "alu",
        [
          [
            "alumni",
            {
              "word": "alumni",
              "text": "a former student"
            }
          ],
          [
            "aluminium",
            {
              "word": "aluminium",
              "text": "a metal"
            }
          ],
          [
            "aluminum",
            {
              "word": "aluminum",
              "text": "a metal"
            }
          ]
        ],
        null
      ],
      [
        "alp",
        [
          [
            "alphabet",
            {
              "word": "alphabet",
              "text": "a kind of writing system"
            }
          ]
        ],
        null
      ],
      ["b",
      [],
      null]
    ];
//.........................................................................................................
    for (i = 0, len = probes_and_matchers.length; i < len; i++) {
      [probe, matcher, error] = probes_and_matchers[i];
      await T.perform(probe, matcher, error, function() {
        return new Promise(function(resolve, reject) {
          var result;
          result = triode[probe];
          // urge jr [ probe, result, null, ]
          resolve(result);
          return null;
        });
      });
    }
    done();
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  this["sorting 1"] = async function(T, done) {
    var error, i, len, matcher, probe, probes_and_matchers, triode;
    triode = TRIODE.new({
      sort: 'text'
    });
    triode['aluminum'] = {
      word: 'aluminum',
      text: '05 a metal'
    };
    triode['aluminium'] = {
      word: 'aluminium',
      text: '04 a metal'
    };
    triode['alumni'] = {
      word: 'alumni',
      text: '02 a former student'
    };
    triode['alphabet'] = {
      word: 'alphabet',
      text: '03 a kind of writing system'
    };
    triode['abacus'] = {
      word: 'abacus',
      text: '01 a manual calculator'
    };
    //.........................................................................................................
    probes_and_matchers = [
      [
        "a",
        [
          [
            "abacus",
            {
              "word": "abacus",
              "text": "01 a manual calculator"
            }
          ],
          [
            "alumni",
            {
              "word": "alumni",
              "text": "02 a former student"
            }
          ],
          [
            "alphabet",
            {
              "word": "alphabet",
              "text": "03 a kind of writing system"
            }
          ],
          [
            "aluminium",
            {
              "word": "aluminium",
              "text": "04 a metal"
            }
          ],
          [
            "aluminum",
            {
              "word": "aluminum",
              "text": "05 a metal"
            }
          ]
        ],
        null
      ],
      [
        "alu",
        [
          [
            "alumni",
            {
              "word": "alumni",
              "text": "02 a former student"
            }
          ],
          [
            "aluminium",
            {
              "word": "aluminium",
              "text": "04 a metal"
            }
          ],
          [
            "aluminum",
            {
              "word": "aluminum",
              "text": "05 a metal"
            }
          ]
        ],
        null
      ],
      [
        "alp",
        [
          [
            "alphabet",
            {
              "word": "alphabet",
              "text": "03 a kind of writing system"
            }
          ]
        ],
        null
      ],
      ["b",
      [],
      null]
    ];
//.........................................................................................................
    for (i = 0, len = probes_and_matchers.length; i < len; i++) {
      [probe, matcher, error] = probes_and_matchers[i];
      await T.perform(probe, matcher, error, function() {
        return new Promise(function(resolve, reject) {
          var result;
          result = triode[probe];
          resolve(result);
          return null;
        });
      });
    }
    done();
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  this["sorting 2"] = async function(T, done) {
    var error, i, len, matcher, probe, probes_and_matchers, triode;
    triode = TRIODE.new({
      sort: true
    });
    triode['aluminum'] = {
      word: 'aluminum',
      text: '05 a metal'
    };
    triode['aluminium'] = {
      word: 'aluminium',
      text: '04 a metal'
    };
    triode['alumni'] = {
      word: 'alumni',
      text: '02 a former student'
    };
    triode['alphabet'] = {
      word: 'alphabet',
      text: '03 a kind of writing system'
    };
    triode['abacus'] = {
      word: 'abacus',
      text: '01 a manual calculator'
    };
    //.........................................................................................................
    probes_and_matchers = [
      [
        "a",
        [
          [
            "abacus",
            {
              "word": "abacus",
              "text": "01 a manual calculator"
            }
          ],
          [
            "alphabet",
            {
              "word": "alphabet",
              "text": "03 a kind of writing system"
            }
          ],
          [
            "aluminium",
            {
              "word": "aluminium",
              "text": "04 a metal"
            }
          ],
          [
            "aluminum",
            {
              "word": "aluminum",
              "text": "05 a metal"
            }
          ],
          [
            "alumni",
            {
              "word": "alumni",
              "text": "02 a former student"
            }
          ]
        ],
        null //! expected result: [["abacus",{"word":"abacus","text":"01 a manual calculator"}],["alumni",{"word":"alumni","text":"02 a former student"}],["alphabet",{"word":"alphabet","text":"03 a kind of writing system"}],["aluminium",{"word":"aluminium","text":"04 a metal"}],["aluminum",{"word":"aluminum","text":"05 a metal"}]]
      ],
      [
        "alu",
        [
          [
            "aluminium",
            {
              "word": "aluminium",
              "text": "04 a metal"
            }
          ],
          [
            "aluminum",
            {
              "word": "aluminum",
              "text": "05 a metal"
            }
          ],
          [
            "alumni",
            {
              "word": "alumni",
              "text": "02 a former student"
            }
          ]
        ],
        null //! expected result: [["alumni",{"word":"alumni","text":"02 a former student"}],["aluminium",{"word":"aluminium","text":"04 a metal"}],["aluminum",{"word":"aluminum","text":"05 a metal"}]]
      ],
      [
        "alp",
        [
          [
            "alphabet",
            {
              "word": "alphabet",
              "text": "03 a kind of writing system"
            }
          ]
        ],
        null
      ],
      ["b",
      [],
      null]
    ];
//.........................................................................................................
    for (i = 0, len = probes_and_matchers.length; i < len; i++) {
      [probe, matcher, error] = probes_and_matchers[i];
      await T.perform(probe, matcher, error, function() {
        return new Promise(function(resolve, reject) {
          var result;
          result = triode[probe];
          resolve(result);
          return null;
        });
      });
    }
    done();
    return null;
  };

  //###########################################################################################################
  if (module.parent == null) {
    test(this);
  }

  // test @[ "selector keypatterns" ]
// test @[ "select 2" ]

}).call(this);

//# sourceMappingURL=main.test.js.map