package also;

use strict;
use warnings;

our $VERSION = "0.01";

use Carp;

sub import_into ($@) {
    my $call = shift;
    my $me = __PACKAGE__;

    $call eq $me and croak qq{can't "use $me" from within $me::};

    for (@_) {
    	my @args = @$_;
        my $mod = shift @args;
	$mod eq $me and croak qq{can't "use $me '$me'"};
	eval "package $call;" . '$mod->import(@args)';
    }
}
 
sub import {
    shift;
    my @imports;

    while (my $mod = shift) {
    	eval "require $mod; 1"; # 5.8.0 bug
	$@ and croak $@;
	
        if (ref $_[0]) {
	    my $args = shift;
	    @$args and push @imports, [$mod, @$args];
	} else {
	    push @imports, [$mod];
	}
    }

    my $call = caller;
    import_into $call, @imports; 

    my $import = $call->can("import") || sub { 1 };
    my $wrap = sub {
	import_into caller, @imports;
	goto &$import;
    };
    
    no strict 'refs';
    no warnings 'redefine';
    *{"${call}::import"} = $wrap;
}

1;

=head1 NAME

also - pragma to export a module into your caller's namespace

=head1 SYNOPSIS

My/Mod.pm:

    package My::Mod;

    use also 'My::OtherMod' => [ qw/foo bar/ ];

program:

    use My::Mod;

this is now effectively:

    use My::Mod;
    use My::OtherMod qw/foo bar/;

=head1 DESCRIPTION

C<also> will export a module into your caller's namespace as well 
as yours. It does this by replacing your C<import> method with one which
does the imports and then calls the original: this means that you must
define your C<import> method before you C<use all>. If you don't and you
have warnings turned on you will get a "Subroutine import redefined"
warning.

The arguments to C<use also> are modules to import. If a module name is
followed by an arrayref, its contents are passed as the arguments to that
module's import function; if the arrayref is empty (i.e. if you write

    use also 'My::Mod' => [];

) then the module's C<import> function will not be called at all. (This will
have the same effect as

    use My::Mod ();

, and thus is perhaps rather pointless :).

=head1 AUTHOR

Ben Morrow <also-pm@morrow.me.uk>

=head1 COPYRIGHT

Copyright 2004 Ben Morrow.

This program is released under the same terms as Perl.

=cut


