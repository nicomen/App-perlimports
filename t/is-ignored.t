use strict;
use warnings;

use lib 't/lib';

use App::perlimports ();
use Test::More import => [qw( diag done_testing is ok subtest )];

subtest 'Types::Standard' => sub {
    my $e = App::perlimports->new(
        filename    => 'lib/App/perlimports.pm',
        source_text => 'use Types::Standard;',
    );
    is(
        $e->_module_name, 'Types::Standard',
        '_module_name'
    );
    ok( $e->_is_ignored, 'noop' );
};

subtest 'Test::RequiresInternet' => sub {
    my $e = App::perlimports->new(
        filename    => 't/test-data/noop.t',
        source_text =>
            q{use Test::RequiresInternet ('www.example.com' => 80 );},
    );
    is(
        $e->_module_name, 'Test::RequiresInternet',
        '_module_name'
    );

    # This is not currently treated as a noop, since we have imports. We just
    # don't know what can be exported. It will basically pass through without
    # changes, though.
    ok( !$e->_is_ignored, 'noop' );
    is(
        $e->formatted_import_statement,
        q{use Test::RequiresInternet ('www.example.com' => 80 );}
    );
};

done_testing();
