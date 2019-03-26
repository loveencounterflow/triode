
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
# order does not matter for the `set()` calls:
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
kb = triode.replacements_as_js_function()
# and now we can use `kb()` to replace from `'ki'` to `'き'` and so on:
current_line = kb current_line
```

So far, triode has done very little: it only sorted the keys from longest to shortest, built the source
code and `eval()`ed it. However, it can do a little more, for example, assist in finding and resolving
ambiguities in the key definitions.

The problem starts when we want to add 'ん' to our table. This is the so-called 'moraic nasal' of Japanese,
and it's commonly transcribed as `n`, `m` or `ɴ` (in linguistic texts), so it would be natural to include it
as `n` in our keyboard definition: `triode.set 'n', 'ん'`. But this creates a problem: `n` is now the key to
a replacement rule *and* the prefix to a number of other replacements, such as `na ⇒ な`, `nyo ⇒ にょ` and so
on. This means when we perform replacements after each keystroke, and we want to write 'な' (`na`), then we
have to first hit `n`, which gets turned into 'ん', and then `a`:

```
[n]   ⇒ ん
ん[a] ⇒ んa
```

It turns out that we can never reach the point where the `na ⇒ な` rule becomes active because a prefix of
its key is also used for another replacement.

The least that `triode` can do for you is to search for and list all the 'keys that are prefixes of other
keys' (more memorably called sub- and superkeys from here on). At this point, when you call
`triode.get_all_superkeys()`, you will get a (possibly empty) object with sub- and superkeys:

```coffee
triode.get_all_superkeys()
# returns `{ n: [ 'na', 'ne', 'ni', 'no', 'nu', 'nya', 'nyo', 'nyu' ] }`
```

What's more, there's not only a way to detect these kinds of problems, there's also ways to resolve
them, primarily through two methods:

* **`triode.disambiguate_subkey = ( old_key, new_key ) ->`** Using this method you could use some heretofore
  unused sequence of letters to replace the ambiguous one; for example, there's hardly a use for letter `x`
  when transliterating Kana, so you might `triode.replace 'n', 'x'`. Chances are you want to do that
  replacement in the translation table rather than fix it later.

  But there's another option: use a disambiguating extra key as a prefix or suffix, e.g. `triode.replace
  'n', 'n.'` to allow users to type `[n]`, `[period]` to get 'ん'. One can imagine this to become a user
  setting, so it makes sense to employ the API to dynamically change it; some users might not want the
  period to interfere with punctuation input, so then they can use some other key for the purpose.

  The advantage in using `triode.disambiguate_subkey()` over `triode.replace()` is that the former checks
  that the old key is indeed ambiguous, that the new key is free and will not introduce new ambiguities and
  so forth to keep you from making an unusable translation table.

* **`triode.apply_replacements_recursively = ( key ) ->`** There's yet another way to deal with sub- and
  superkeys, and that is to change the replacement expressions. Above, we have seen that after `n ⇒ ん` has
  been performed and key `a` is then hit, we have `んa` in the text input so rule `na ⇒ な` can never fire.
  *But* what if we rewrote that rule as `んa ⇒ な`? This is exactly what `apply_replacements_recursively()`
  does: given a subkey, it will rewrite all superkeys such that they start with the subkeys (`n` in our
  case) value (i.e. `ん`).

Now, while it may seem that the aformentioned method of just fixing the superkeys solves all problems, this
in fact has a serious drawback, because when you take the above translation table and apply recursive
replacements to it, some Kana combinations remain in fact unwritable:


| transcription | translit. 1 | translit. 2 | expected   | output     | input  | interpretation    |
|:--------------|:------------|:------------|:------     |:---        |:---    |:----------------|
| sanyo         | sa’nyō      | sanyō       | さにょう   | さにょう   | sanyo  | ?               |
| sanyo         | san’yō      | saɴyō       | さんよう   | さにょう❎ | sanyo  |  山陽, 算用, ...     |
| sannyo        | san’nyō     | saɴnyō      | さんにょう | さんにょう | sannyo | sec. form of 算用 |
| sanki         | sanki       | saɴki       | さんき     | さんき     | sanki  | 山気, 三機          |



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

