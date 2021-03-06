use Find::Lib '../lib';
use strict;
use warnings;
use Test::More tests => 12;

use_ok 'Data::Layered';
use Data::Layered 'layered_get';

my $keys;
my $r = layered_get();
isa_ok $r, 'ARRAY';
is scalar @$r, 0, "no data returned";

is_deeply layered_get([], []), [], 'no data returned';

## define some caches
my $L1 = {
    a => '1',
    c => '3',
};

my $L2 = {
    A => '1',
    B => '2',
};

my $l1 = sub { [ @$L1{ @{$_[0]} } ] };
my $l2 = sub { [ @$L2{ @{$_[0]} } ] };

$keys = [qw/ a a A b B c C /];
$r = layered_get($keys, [ $l1, $l2 ]);
isa_ok $r, 'ARRAY';
is scalar @$r, scalar @$keys, "same size than input";
is_deeply $r, [ '1', '1', '1', undef, '2', '3', undef ], "yeah";

my $l1_2 = sub { [ map { defined $_ ? $_ : -1 } @$L1{ @{$_[0]} } ] };
my $l2_2 = sub { [ map { defined $_ ? $_ : -1 } @$L2{ @{$_[0]} } ] };
$r = layered_get($keys, [ $l1_2, $l2_2 ], -1);
is_deeply $r, [ '1', '1', '1', -1, '2', '3', -1 ], "with explicit miss value";

$L1->{b} = -1;
$L2->{b} = 'got it';
$r = layered_get($keys, [ $l1_2, $l2_2 ], -1);
is_deeply $r, [ '1', '1', '1', 'got it', '2', '3', -1 ],
          "explicit miss from layer";

$L1->{b} = undef;
$L2->{b} = 'got it';

$r = layered_get($keys, [ $l1, $l2 ]);
is_deeply $r, [ '1', '1', '1', 'got it', '2', '3', undef ],
          "explicit miss from layer(with undef)";

my @misses = ();
$l1 = sub {
    my $in = $_[0];
    my $out = $_[1];
    my $res = [ @$L1{ @$in } ];
    for (my $i = 0; $i< @$res; $i++) {
        if (! defined $res->[$i]) {
            push @misses, [ $in->[$i], $out->[$i] ];
        }
    }
    return $res;
};

$r = layered_get($keys, [ $l1, $l2 ]);
is_deeply [ map { $_->[0] } @misses ], [qw/ A b B C /], "miss keys recorded";
is_deeply [ map { defined $_ ? ${$_->[1]} : $_ } @misses ],
          [ '1', 'got it', '2', undef ],
          "The actual values are now populated";
