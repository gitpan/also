package t::RealSub;

sub manual_export { 1 }

sub import {
    shift;
    my $call = caller;
    *{"${call}::manual_export"} = \&manual_export;
}

use also 't::Used';

1;
