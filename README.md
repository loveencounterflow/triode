
<center><img src='https://upload.wikimedia.org/wikipedia/commons/thumb/1/19/Dubulttriode_darbiibaa.jpg/364px-Dubulttriode_darbiibaa.jpg'></center>

# Triode

A thin wrapper for [`mnemonist/trie-map`](https://yomguithereal.github.io/mnemonist/trie-map); it uses a JS
Proxy to provide a dictionary-like interface and a convenient way to sort result sets.

TRIODE objects allow to associate keys to arbitrary values with `t.set( k, v )`, where `k` is an 'index
key', and to retrieve all matching entries (pairs `[ k, v ]`) with `r = t.find( p )`, where `p` is a
'pseudo-' or 'prefix-key' that is tested against the first characters of all index keys.

Example:

```coffee
# when initialized as ...
triode = TRIODE.new { sort: 'textio', }
triode.set 'aluminum', 	{ word: 'aluminum',   text: '05 a metal',                  }
triode.set 'aluminium',	{ word: 'aluminium',  text: '04 a metal',                  }
triode.set 'alumni',   	{ word: 'alumni',     text: '02 a former student',         }
triode.set 'alphabet', 	{ word: 'alphabet',   text: '03 a kind of writing system', }
triode.set 'abacus',   	{ word: 'abacus',     text: '01 a manual calculator',      }

# ...then retrieving pseudo-key 'alu' ...
triode.find 'alu'

# ...will return this list of matches, sorted by the 'text' attribute:
[ [ 'alumni',     { word: 'alumni',     text: '02 a former student', }, ],
  [ 'aluminium',  { word: 'aluminium',  text: '04 a metal',          }, ],
  [ 'aluminum',   { word: 'aluminum',   text: '05 a metal',          }, ] ]
```

Possible values for the optional `sort` setting are `false` (don't sort), `true` (sort by the index term),
or a string with the name of attribute of the target value. The default is not to sort results.

