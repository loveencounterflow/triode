
<center><img width=100 src='https://upload.wikimedia.org/wikipedia/commons/thumb/1/19/Dubulttriode_darbiibaa.jpg/364px-Dubulttriode_darbiibaa.jpg'></center>

# Triode

a JavaScript P(lain) O(ld) D(ictionary) with element access by prefixes, implemented with a trie. The name
is both a pun on 'trie' and a hint to the 'amplifying' nature of prefix matches: you enter a small amount
of data to get results for something that was indexed with a bigger amount of data.

```coffee
TRIODE = require 'triode'
triode = TRIODE.new()
triode[ 'aluminum'    ] = { word: 'aluminum', text: 'a metal', }
triode[ 'aluminium'   ] = { word: 'aluminium', text: 'a metal', }
triode[ 'alumni'      ] = { word: 'alumni', text: 'a former student', }
triode[ 'alphabet'    ] = { word: 'alphabet', text: 'a kind of writing system', }
triode[ 'abacus'      ] = { word: 'abacus', text: 'a manual calculator', }

try
  triode[ 'alu' ]
catch error
  ### unspecific prefix 'a' ###
  warn error[ 'message' ]

### { word: 'alumni', text: 'a former student' } ###
info triode[ 'alumn' ]

### { word: 'alphabet', text: 'a kind of writing system' } ###
info triode[ 'alp' ]

delete triode[ 'alp' ]
### undefined ###
info triode[ 'alp' ]
```



