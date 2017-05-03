## Terms

#### `Window`

A "sliding window" Str that on a Kitten contains the head of the
string and (possibly more than one) parts that were already read from the
source. All operations operate on the Window, as needed appending more chunks
read from source to it.

On a FatCat, already-processed parts will be stored somewhere, so the Window
can slide back to previous positions.

## Iterator-based methods

For iterator-based methods (e.g. `.words`, `.lines`, `.comb`), use original
`Str` methods on the Window
