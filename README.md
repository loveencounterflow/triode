
<center><img src='https://upload.wikimedia.org/wikipedia/commons/thumb/1/19/Dubulttriode_darbiibaa.jpg/364px-Dubulttriode_darbiibaa.jpg'></center>

# Triode

## What's a Triode?

`triode` is a <strike>thin</strike> wrapper for
[`mnemonist/trie-map`](https://yomguithereal.github.io/mnemonist/trie-map) with added functionality geared
towards input method generation; this code is used by [the MingKwai TypeWriter
明快打字机](https://github.com/loveencounterflow/mingkwai-typewriter), to generate translation tables e.g. for
the input of Greek, Cyrillic and Kana input with Latin keyboards.

## Basic Functionality

TRIODE objects allow to associate keys to arbitrary values with `t.set( k, v )`, where `k` is an 'index
key', and to retrieve all matching entries (pairs `[ k, v ]`) with `r = t.find( p )`, where `p` is a
'pseudo-' or 'prefix-key' that is tested against the first characters of all index keys.

Example:

```coffee
# when initialized as ...
triode = TRIODE.new { sort: 'textio', }
triode.set 'aluminum',  { word: 'aluminum',   text: '05 a metal',                  }
triode.set 'aluminium', { word: 'aluminium',  text: '04 a metal',                  }
triode.set 'alumni',    { word: 'alumni',     text: '02 a former student',         }
triode.set 'alphabet',  { word: 'alphabet',   text: '03 a kind of writing system', }
triode.set 'abacus',    { word: 'abacus',     text: '01 a manual calculator',      }

# ...then retrieving pseudo-key 'alu' ...
triode.find 'alu'

# ...will return this list of matches, sorted by the 'text' attribute:
[ [ 'alumni',     { word: 'alumni',     text: '02 a former student', }, ],
  [ 'aluminium',  { word: 'aluminium',  text: '04 a metal',          }, ],
  [ 'aluminum',   { word: 'aluminum',   text: '05 a metal',          }, ] ]
```

Possible values for the optional `sort` setting are `false` (don't sort), `true` (sort by the index term),
or a string with the name of attribute of the target value. The default is not to sort results.

## Resolution of Ambiguities and JS Code Generation

`triode` may be used to define and generate keyboard in put methods. For this purpose, a values should be
strings (not objects or anything else).

As an example, say we wanted to generate an (incomplete) input method for Japanese Kana. We want to
implement this as a text replacement function that replaces text as input into an HTML text area or similar
element on each keystroke:

```coffee
kb = ( text ) =>
  R = text;
  R = R.replace /nya$/, 'にゃ'
  R = R.replace /nyu$/, 'にゅ'
  R = R.replace /nyo$/, 'にょ'
  R = R.replace /ka$/,  'か'
  R = R.replace /ki$/,  'き'
  R = R.replace /ku$/,  'く'
  R = R.replace /ke$/,  'け'
  R = R.replace /ko$/,  'こ'
  R = R.replace /na$/,  'な'
  R = R.replace /ni$/,  'に'
  R = R.replace /nu$/,  'ぬ'
  R = R.replace /ne$/,  'ね'
  R = R.replace /no$/,  'の'
  ...
  return R
````

To obtain the above function (or its source code), we use `triode`:

```coffee
triode = TRIODE.new()
triode.set 'nya', 'にゃ'
triode.set 'nyu', 'にゅ'
triode.set 'nyo', 'にょ'
triode.set 'ka',  'か'
triode.set 'ki',  'き'
triode.set 'ku',  'く'
triode.set 'ke',  'け'
triode.set 'ko',  'こ'
triode.set 'na',  'な'
triode.set 'ni',  'に'
triode.set 'nu',  'ぬ'
triode.set 'ne',  'ね'
triode.set 'no',  'の'
...
```

## API

### Basics

* **`@set = ( key, value ) ->`** Associates a key with a value; duplicates will replace old settings
  without warning.

* **`@get = ( key ) ->`** Get the value associated with a key, or `undefined` if not set (this method may
  be changed to throw an error for unknown keys in a future version).

* **`@delete = ( key ) ->`** Delete a key (this method may
  be changed to throw an error for unknown keys in a future version).

* **`@find = ( prefix ) ->`** Return a (possibly empty) list of all matching key/value pairs for a given
  prefix. This list will be sorted if the instance has been configured accordingly, see above.

* **`@replace = ( old_key, new_key ) ->`** Given an old and a new key, delete the old key and associate its
  value with the new key. An error will be thrown if the old key does not or the new key does exist to
  prevent accidental overwriting.


### Sub/Superkey Detection

* **`@get_all_superkeys = ->`** Get an object whose keys are triode keys that are subkeys (prefixes of other
  keys) and whose values are lists of superkeys.

* **`@get_keys_sorted_by_length_asc  = ->`**, **`@get_keys_sorted_by_length_desc = ->`** Return a list of
  keys sorted by ascending or descending length; within each length group, keys are again sorted
  lexicographically for better result stability.

* **`@get_longer_keys = ( key ) ->`** Return a list of all keys that are longer than the one given. This is
  primarily used internally to find superkeys.

* **`@has_superkeys = ->`** Return whether there are any sub/superkey pairs in the triode; JS code will only
  be generated when this method returns false.

* **`@superkeys_from_key = ( key ) ->`** Given a key, return a (possibly empty) list of its superkeys.
  Throws an error if key is unknown.

### Resolution of Ambiguities

* **`@apply_replacements_recursively = ( key ) ->`** Given a key, replace the prefixes of all superkeys with
  the value of the key. Throws an error if key is unknown.

* **`@disambiguate_subkey = ( old_key, new_key ) ->`** Given a subkey, replace it with a new one to resolve
  ambiguities. Throws an error if the old key is not known or the new one is already known, or if the old
  key is not a subkey, or the the new one turns out to be a subkey.


### Method and Source Generation


* **`@replacements_as_js_function = ( name ) ->`** Returns a ready-to-use function that performs all the
  replacements described by the triode's key/value pairs.

* **`@replacements_as_js_function_text = ( name ) ->`** Return the source text for a JS function that turns
  all triode entries (from longest to shortest keys) into `text = text.replace /<key>$/, $value` statements.

* **`@replacements_as_js_module_text = ( name ) ->`** Same as `replacements_as_js_function()`, but wrapped
  as a CommonJS module; when written to a file `keyboard.js`, then `kb = require 'keyboard.js'` will return
  the replacement function described above.

