// Generated by CoffeeScript 1.12.2
(function() {
  var CND, MNEMONIST, badge, debug, echo, error, help, i, idx, info, len, r, rpr, urge, warn, word, words, Σ_missing;

  CND = require('cnd');

  rpr = CND.rpr;

  badge = 'TRIODE';

  debug = CND.get_logger('debug', badge);

  urge = CND.get_logger('urge', badge);

  info = CND.get_logger('info', badge);

  help = CND.get_logger('help', badge);

  warn = CND.get_logger('warn', badge);

  echo = CND.echo.bind(CND);

  MNEMONIST = require('mnemonist');

  Σ_missing = Symbol('missing');

  this["new"] = function() {
    var deleteProperty, get, resolve, set, store, trie;
    trie = new MNEMONIST.Trie();
    store = {};
    resolve = function(prefix) {
      var keys;
      keys = trie.get(prefix);
      if (keys.length === 0) {
        return Σ_missing;
      }
      if (keys.length !== 1) {
        throw new Error("unspecific prefix " + (rpr(prefix)));
      }
      return keys[0];
    };
    set = (function(_this) {
      return function(_, key, value) {
        trie.add(key);
        return store[key] = value;
      };
    })(this);
    get = (function(_this) {
      return function(_, prefix) {
        return store[resolve(prefix)];
      };
    })(this);
    deleteProperty = function(_, prefix) {
      return delete store[resolve(prefix)];
    };
    return new Proxy(store, {
      get: get,
      set: set,
      deleteProperty: deleteProperty
    });
  };

  words = ['33333333', '306ca2f7994a35eef-460-jpg', '00d59e245c257deb6-445-jpg'];

  r = this["new"]();

  for (idx = i = 0, len = words.length; i < len; idx = ++i) {
    word = words[idx];
    r[word] = {
      word: word,
      idx: idx
    };
  }

  try {
    info('1', r['3']);
  } catch (error1) {
    error = error1;
    warn(error['message']);
  }

  info('2', r['30']);

  info('3', r['00d59']);

  info('4', r['ffffffff']);

  delete r['00d59'];

  help(r);

  info('5', r['00d59']);

  try {
    delete r['3'];
  } catch (error1) {
    error = error1;
    warn(error['message']);
  }

  help(r);

  info('6', r['00d59']);

}).call(this);

//# sourceMappingURL=main.js.map