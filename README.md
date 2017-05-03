[![Build Status](https://travis-ci.org/zoffixznet/perl6-Kitten.svg)](https://travis-ci.org/zoffixznet/perl6-Kitten)

# NAME

Kitten - Perl 6 Cat, aka lazy strings, except baby-sized

# SYNOPSIS

```perl6
    use Kitten;
                        # infinite list of letters, with an occasional space
    my Kitten $kit .= new: { (' ', |('a'..'z')).pick } … *;

    # Lazily make two words from that list:
    say $kit.words[^2]; # OUTPUT: «("tkdkvyjhvpszbdedozbmbl", "ffwyyvdmnq")␤»

    # Lazily split the Cat on some regex:
    say $kit.split(/perl/)[^2]; # OUTPUT: «("adasz", "zffwnq")␤»

    # Lazily read off a filehandle and process string as words:
    my Kitten $kit .= new: { state $fh = "large-file".IO.open; $fh.get } … *;
    .say for $kit.words;
```

# DESCRIPTION

Work with lazily-evaluated strings in Perl 6

----

#### REPOSITORY

Fork this module on GitHub:
https://github.com/zoffixznet/perl6-Kitten

#### BUGS

To report bugs or request features, please use
https://github.com/zoffixznet/perl6-Kitten/issues

#### AUTHOR

Zoffix Znet (https://perl6.party/)

#### LICENSE

You can use and distribute this module under the terms of the
The Artistic License 2.0. See the `LICENSE` file included in this
distribution for complete details.
