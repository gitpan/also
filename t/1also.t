use Test::More tests => 7;

use_ok 'also';

sub use_now {
    my $mod = shift;
    eval "require $mod; 1";
    $@ and die $@;
    import $mod @_;
}

use_now 't::NoImport::NoArgs';
ok exists &export, "import called";
ok !exists &export_ok, "import called w/ no args";

use_now 't::NoImport::Args';
ok exists &export_ok, "import called w/ args";

use_now 't::RealSub';
ok exists &manual_export, "original import called";

use_now 't::Inherit';
ok exists &inherit_export, "inherited import called";

use_now 't::Inherit' => qw/inherit_export_ok/;
ok exists &inherit_export_ok, "inherited export called w/ args";
