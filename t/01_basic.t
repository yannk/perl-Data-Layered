use Find::Lib '../lib';
use strict;
use warnings;
use Test::More tests => 3;

use_ok 'Data::Layered';
use Data::Layered 'layered_get';

my $res = layered_get();
isa_ok $res, 'ARRAY';
is scalar @$res, 0;

