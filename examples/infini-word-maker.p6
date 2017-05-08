use lib <lib ../lib>;

use Kitten;

my Kitten $kit .= new: 'fo', 'o', ' ', 'bar ', 'ber';
# { (' ', |('a'..'z')).pick } … *;
.say for $kit.words;
