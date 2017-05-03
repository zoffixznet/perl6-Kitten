use lib <lib ../lib>;

use Kitten;

my Kitten $kit .= new: { (' ', |('a'..'z')).pick } … *;
.say for $kit.words;
