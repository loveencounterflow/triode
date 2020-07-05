(function() {
  //###########################################################################################################
  var CND, TrieMap, badge, cast, debug, echo, help, info, isa, jr, rpr, type_of, types, urge, validate, warn;

  CND = require('cnd');

  rpr = CND.rpr;

  badge = 'TRIODE';

  debug = CND.get_logger('debug', badge);

  urge = CND.get_logger('urge', badge);

  info = CND.get_logger('info', badge);

  help = CND.get_logger('help', badge);

  warn = CND.get_logger('warn', badge);

  echo = CND.echo.bind(CND);

  //...........................................................................................................
  ({jr} = CND);

  TrieMap = require('mnemonist/trie-map');

  types = new (require('intertype')).Intertype();

  ({isa, validate, cast, type_of} = types);

  //-----------------------------------------------------------------------------------------------------------
  this.new = function(settings) {
    var f, trie;
    f = function() {
      var by_length_asc, by_length_desc, do_sort, sort_method;
      //.......................................................................................................
      by_length_asc = function(a, b) {
        if (a.length < b.length) {
          return -1;
        }
        if (a.length > b.length) {
          return +1;
        }
        if (a < b) {
          return -1;
        }
        if (a > b) {
          return +1;
        }
        return 0;
      };
      //.......................................................................................................
      by_length_desc = function(a, b) {
        if (a.length > b.length) {
          return -1;
        }
        if (a.length < b.length) {
          return +1;
        }
        if (a < b) {
          return -1;
        }
        if (a > b) {
          return +1;
        }
        return 0;
      };
      //.......................................................................................................
      do_sort = null;
      if ((do_sort = settings != null ? settings.sort : void 0) != null) {
        if (do_sort === false) {
          null;
        } else if (do_sort === true) {
          sort_method = function(a, b) {
            if (a[0] < b[0]) {
              return -1;
            }
            if (a[0] > b[0]) {
              return +1;
            }
            return 0;
          };
        } else if (isa.text(do_sort)) {
          sort_method = function(a, b) {
            if (a[1][do_sort] < b[1][do_sort]) {
              return -1;
            }
            if (a[1][do_sort] > b[1][do_sort]) {
              return +1;
            }
            return 0;
          };
        } else {
          throw new Error(`µ57633 expected a text or a boolean, got a ${type_of(do_sort)}`);
        }
      }
      //.......................................................................................................
      this.find = function(prefix) {
        var R;
        R = trie.find(prefix);
        if (sort_method != null) {
          R.sort(sort_method);
        }
        return R;
      };
      //.......................................................................................................
      this.get_keys_sorted_by_length_asc = function() {
        return [...this.keys()].sort(by_length_asc);
      };
      this.get_keys_sorted_by_length_desc = function() {
        return [...this.keys()].sort(by_length_desc);
      };
      //.......................................................................................................
      this.get_longer_keys = function(key) {
        var R, i, idx, ref;
        validate.text(key);
        if (!this.has(key)) {
          throw new Error(`µ58275 unknown key ${rpr(key)}`);
        }
        R = this.get_keys_sorted_by_length_asc();
        for (idx = i = 0, ref = R.length; (0 <= ref ? i < ref : i > ref); idx = 0 <= ref ? ++i : --i) {
          if (R[idx].length > key.length) {
            break;
          }
        }
        return R.slice(idx);
      };
      //.......................................................................................................
      this.superkeys_from_key = function(key) {
        var sp;
        validate.text(key);
        if (!this.has(key)) {
          throw new Error(`µ58917 unknown key ${rpr(key)}`);
        }
        return (function() {
          var i, len, ref, results;
          ref = this.get_longer_keys(key);
          results = [];
          for (i = 0, len = ref.length; i < len; i++) {
            sp = ref[i];
            if (sp.startsWith(key)) {
              results.push(sp);
            }
          }
          return results;
        }).call(this);
      };
      //.......................................................................................................
      this.get_all_superkeys = function() {
        var R, key, ref, superprefixes;
        R = {};
        ref = this.keys();
        for (key of ref) {
          if ((superprefixes = this.superkeys_from_key(key)).length > 0) {
            R[key] = superprefixes;
          }
        }
        return R;
      };
      //.......................................................................................................
      /* TAINT use more efficient method */
      this.has_superkeys = function() {
        return (Object.keys(this.get_all_superkeys())).length > 0;
      };
      //.......................................................................................................
      this.disambiguate_subkey = function(old_key, new_key) {
        validate.text(old_key);
        validate.text(new_key);
        //.....................................................................................................
        if ((this.superkeys_from_key(old_key)).length === 0) {
          throw new Error(`µ59880 old key ${rpr(old_key)} is not ambiguous`);
        }
        //.....................................................................................................
        if (this.has(new_key)) {
          throw new Error(`µ60201 new key ${rpr(new_key)} already in use`);
        }
        this.replace(old_key, new_key);
        //.....................................................................................................
        if ((this.superkeys_from_key(new_key)).length !== 0) {
          throw new Error(`µ60522 new key ${rpr(new_key)} is still ambiguous`);
        }
        return null;
      };
      //.......................................................................................................
      this.apply_replacements_recursively = function(key) {
        var i, len, new_superkey, old_superkey, replacement, superkeys;
        validate.text(key);
        //.....................................................................................................
        if ((superkeys = this.superkeys_from_key(key)).length === 0) {
          throw new Error(`µ61164 key ${rpr(key)} is not ambiguous`);
        }
        //.....................................................................................................
        replacement = this.get(key);
//.....................................................................................................
        for (i = 0, len = superkeys.length; i < len; i++) {
          old_superkey = superkeys[i];
          new_superkey = replacement + old_superkey.slice(key.length);
          this.replace(old_superkey, new_superkey);
        }
        return null;
      };
      //.......................................................................................................
      this.replace = function(old_key, new_key) {
        var value;
        //.....................................................................................................
        if (!this.has(old_key)) {
          throw new Error(`µ61485 unknown old key ${rpr(old_key)}`);
        }
        //.....................................................................................................
        if (this.has(new_key)) {
          throw new Error(`µ61806 new key ${rpr(new_key)} already in use`);
        }
        //.....................................................................................................
        value = this.get(old_key);
        this.delete(old_key);
        this.set(new_key, value);
        return null;
      };
      //.......................................................................................................
      this.replacements_as_js_function_text = function() {
        var R, i, key, len, ref, replacement, subkeys;
        if ((subkeys = Object.keys(this.get_all_superkeys())).length > 0) {
          throw new Error(`µ61806 must first resolve subkeys ${rpr(subkeys)}`);
        }
        //.....................................................................................................
        R = [];
        R.push("( text ) => {");
        R.push("  R = text");
        ref = this.get_keys_sorted_by_length_desc();
        for (i = 0, len = ref.length; i < len; i++) {
          key = ref[i];
          replacement = this.get(key);
          R.push(`  R = R.replace( /^${CND.escape_regex(key)}$/, ${rpr(replacement)} );`);
        }
        R.push("  return R; };\n");
        return R.join('\n');
      };
      //.......................................................................................................
      this.replacements_as_js_function = function() {
        return eval(this.replacements_as_js_function_text());
      };
      //.......................................................................................................
      this.replacements_as_js_module_text = function(name) {
        var R, first_line, source;
        source = this.replacements_as_js_function_text();
        ({first_line, source} = (source.match(/^(?<first_line>[^\n]+)\n(?<source>.*)$/ms)).groups);
        R = [];
        R.push("// Generated code, do not edit;");
        R.push(`// edit ${rpr(name)} instead and re-generate.`);
        R.push("");
        R.push(`module.exports = ${first_line}`);
        R.push(source);
        return R.join('\n');
      };
      //.......................................................................................................
      this.toString = function() {
        return this.as_js_function_text();
      };
      //.......................................................................................................
      this.as_js_function_text = function() {
        var R, key, ref, value, x;
        //.....................................................................................................
        R = [];
        R.push("() => {");
        R.push("  R = require( 'triode' ).new();");
        ref = this.entries();
        for (x of ref) {
          [key, value] = x;
          R.push(`  R.set( ${jr(key)}, ${jr(value)} );`);
        }
        R.push("  return R; };\n");
        return R.join('\n');
      };
      //.......................................................................................................
      this.as_js_function = function() {
        return (eval(this.as_js_function_text()))();
      };
      //.......................................................................................................
      this.as_js_module_text = function(name) {
        var R, first_line, source;
        source = this.as_js_function_text();
        ({first_line, source} = (source.match(/^(?<first_line>[^\n]+)\n(?<source>.*)$/ms)).groups);
        R = [];
        R.push("// Generated code, do not edit;");
        R.push(`// edit ${rpr(name)} instead and re-generate.`);
        R.push("");
        R.push(`const f = ${first_line}`);
        R.push(source);
        R.push("module.exports = f();\n");
        return R.join('\n');
      };
      //.......................................................................................................
      return this;
    };
    //.........................................................................................................
    trie = new TrieMap();
    return f.apply(Object.create(trie));
  };

}).call(this);

//# sourceMappingURL=main.js.map