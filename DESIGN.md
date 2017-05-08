## Terms

#### `Window`

A "sliding window" Str that on a Kitten contains the head of the
string and (possibly more than one) parts that were already read from the
source. All operations operate on the Window, as needed appending more chunks
read from source to it.


## Iterator-based methods

Iterator-based methods (e.g. `.words`, `.lines`, `.comb`) use original
`Str` methods on the Window.

**On `pull-one` we need to:**

(`chunk` is the chunk of data we'll be returning from `pull-one` for this
iteration; `peek` is a chunk of data we might end up returning on next
`pull-one`)

1) Do a read to put data into Window, if it lacks any
2) Make an iterator on Window, for the method we want
3) If we have a saved peek, use it as a chunk, otherwise pull a chunk from
  that iterator
4) Pull a new peek from that iterator
5) If chunk and peek are the same string:
    - Invalidate chunk; invalidate peek
    - Pull more data into Window
    - Repeat the process from step (2)
6) Save peek; it'll be our chunk for next pull-one
7) Cut off head of Window the size of the chunk
8) Return chunk

----

When to expand Window:
- The chunk is IterationEnd
- The peek is IterationEnd
- The chunk and peek are same
