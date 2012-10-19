package Test::Role::DateTimeHandler;

use Moose;

with qw/DateTimeHandler::Role/;

no Moose;

package test_role;
use strict;
use Test::More tests => 11;

use DateTimeHandler;
use DateTime;

my $dth = DateTimeHandler->new();
my $role = Test::Role::DateTimeHandler->new;

is( ref $role, 'Test::Role::DateTimeHandler', 'Instantiation of the class consuming the role' );

my $epoch    = 1263475735;
my $date_ref = '2010-01-14T14:28:55+01:00';
my $dt = $dth->dt_from_epoch( $epoch );

my @entries = (
    [ 'time_zone', 'time_zone', ],
    [ 'default_dt_format', 'default_format' ],
    [ 'parse_datetime', 'parse_datetime', $date_ref, 'w3cdtf' ],
    [ 'format_datetime', 'format_datetime', $dt, 'w3cdtf' ],
    [ 'dt_from_epoch', 'dt_from_epoch', $epoch, 'w3cdtf' ],
    [ 'format_epoch', 'format_epoch', $epoch, 'w3cdtf' ],
    [ 'convert_datetime', 'convert_datetime', $date_ref, 'w3cdtf', 'default' ],
    [ 'today', 'today' ],
    [ 'now', 'now' ],
    [ 'add_dt_parser', 'add_parser', 'test', 'le %d %m %Y a %T', 'le 14 01 2010 a 14:28:55', ],
);

foreach my $entry ( @entries ) {
    my ( $accessor, $method, @args ) = @$entry;

    is_deeply( $dth->$method( @args ), $role->$accessor( @args ), "checking accessor $accessor");
}

done_testing;

