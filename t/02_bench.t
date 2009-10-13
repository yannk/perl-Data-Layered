use Find::Lib '../lib';
use strict;
use warnings;
use Benchmark 'timethese';

use Data::Layered 'layered_get', 'layered_get2', 'layered_get3';

## define some caches
my $L1 = {};
my $L2 = {};
my $keys = [];
for (1 .. 50000) {
    $L1->{ int rand (100000) } = int rand (1000);
    $L2->{ int rand (100000) } = int rand (1000);
    push @$keys, int rand (100000);
}
my %seen;
@$keys = grep { ! $seen{$_}++ } @$keys;

my $l1 = sub { [ @$L1{ @{$_[0]} } ] };
my $l2 = sub { [ @$L2{ @{$_[0]} } ] };

my $l1_2 = sub {
    my ($keys, $res) = @_;
    for my $k (@$keys) {
        $res->{$k} = $L1->{$k};
    }
};

my $l2_2 = sub {
    my ($keys, $res) = @_;
    for my $k (@$keys) {
        $res->{$k} = $L2->{$k};
    }
};

timethese 5, {
    layered_get => sub {
        my $res = layered_get( $keys, [ $l1, $l2 ]);
        #warn scalar grep { defined } @$res;
    },
    layered_get2 => sub {
        my $res = layered_get2( $keys, [ $l1_2, $l2_2 ]);
        #warn scalar grep { defined $res->{$_} } keys %$res;
    },

    layered_get3 => sub {
        my $res = layered_get3( $keys, [ $l1_2, $l2_2 ]);
        #warn scalar grep { defined $res->{$_} } keys %$res;
    },
};
