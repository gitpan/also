package t::Inherit;

use base qw/Exporter/;
use also 't::Used';

our @EXPORT = qw/inherit_export/;
our @EXPORT_OK = qw/inherit_export_ok/;

sub inherit_export { 1 }
sub inherit_export_ok { 1 }

1;

