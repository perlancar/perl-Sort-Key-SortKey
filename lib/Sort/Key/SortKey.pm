package Sort::Key::SortKey;

use strict 'subs', 'vars';
use warnings;

use Exporter qw(import);
use Module::Load::Util;
use Sort::Key ();

# AUTHORITY
# DATE
# DIST
# VERSION

our @EXPORT_OK = @Sort::Key::EXPORT_OK;

for my $f (qw/
                 nsort nsort_inplace
                 isort isort_inplace
                 usort usort_inplace
                 rsort rsort_inplace
                 rnsort rnsort_inplace
                 risort risort_inplace
                 rusort rusort_inplace
             /) {
    *{"$f"} = \&{"Sort::Key\::$f"};
}

for my $f (qw/
                 keysort keysort_inplace
                 rkeysort rkeysort_inplace
                 nkeysort nkeysort_inplace
                 rnkeysort rnkeysort_inplace
                 ikeysort ikeysort_inplace
                 rikeysort rikeysort_inplace
                 ukeysort ukeysort_inplace
                 rukeysort rukeysort_inplace
             /) {
    *{"$f"} = sub {
        my $sortkey = shift;
        my $is_numeric = $f =~ /^(n|rn|i|ri|u|ru)/;
        my $ns_prefixes = $is_numeric ? ["SortKey::Num", "SortKey"] : ["SortKey"];
        my ($mod, $args) = Module::Load::Util::_normalize_module_with_optional_args($sortkey);
        $mod = Module::Load::Util::_load_module({ns_prefixes=>$ns_prefixes}, $mod);
        my $keygen = &{"$mod\::gen_keygen"}(@$args);
        &{"Sort::Key::$f"}(sub { $keygen->($_) }, @_);
    };
}

for my $f (qw/
                 multikeysorter multikeysorter_inplace
             /) {
    # XXX currently we don't wrap
    *{"$f"} = \&{"Sort::Key\::$f"};
}

1;
# ABSTRACT: Thin wrapper for Sort::Key to easily use SortKey::*

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

 use Sort::Key::SortKey qw(nkeysort);

 my @sorted = nkeysort "pattern_count=string.foo", @items; # see SortKey::Num::pattern_count
 my @sorted = nkeysort [pattern_count => {string=>"foo"}], @items; # ditto
 ...


=head1 DESCRIPTION

This is a thin wrapper for L<Sort::Key>. Instead of directly specifying a
codeblock, you specify a L<SortKey> module name with optional arguments.


=head1 SEE ALSO

L<Sort::Key>

L<SortKey>
