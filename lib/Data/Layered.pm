package Data::Layered;

use strict;
use 5.008_001;
our $VERSION = '0.01';
use Exporter;
use vars '@EXPORT_OK';

@ISA = qw(Exporter);
@EXPORT_OK = qw(layered_get);

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

=back

though, there is no assumption made by this module about the type
of these stores, their topography or their response time.

=head1 METHODS

There is only one method that you can import into your package.

=head2 layered_get($keys, $layers, $miss_value)

Return a reference to a list of results (in the same order that the C<$keys>),
corresponding to the list of keys passed in the C<$keys> array ref.

C<$layers> is a list reference of code references taking in parameter a
list of keys (a subset of C<$keys>) and returning a reference to a list of
results.

C<$miss_value> defines the B<miss> value that all layers understand.

=head1 AUTHOR

Yann Kerherve E<lt>yannk@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut

1;
