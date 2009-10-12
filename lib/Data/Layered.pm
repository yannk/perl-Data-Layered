package Data::Layered;

use strict;
use 5.008_001;
our $VERSION = '0.01';

=encoding utf-8

=head1 NAME

Data::Layered - Access data using layered data store (typically caches)

=head1 SYNOPSIS

  use Data::Layered 'layered_get';

  $keys = [ 'what', 'ever' ];
  $layers = [ \&fast_small_cache, \&network_cache, \&slow_backend ];

  $results = layered_get $keys, $layers;
  $results = layered_get $keys, $layers, -1;

  for (@$results) {
      if ($_ && $_ == '-1') {
         warn "Oh, no, 404 not found";
      }
      print "Happy result: $_\n";
  }


=head1 DESCRIPTION

Data::Layered implements a small utility method to help you retrieve
some quantity of data out of hierarchical datastores. The typical
use case is to retrieve data from:

=over 4

=item * local memory cache

=item * network memory cache (memcached)

=item * canonical datastore

=cut

though, there is no assumption made by this module about the type
of these stores, their topography or their response time.

=head1 AUTHOR

Yann Kerherve E<lt>yannk@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut

1;
