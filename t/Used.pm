package t::Used;

use base 'Exporter';

our @EXPORT = qw/export/;
our @EXPORT_OK = qw/export_ok/;

sub export { 1 }
sub export_ok { 1 }

1;

