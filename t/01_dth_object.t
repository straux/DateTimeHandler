use strict;
use Test::More tests => 28;

use DateTimeHandler;
use DateTime;

my $dth = DateTimeHandler->new( time_zone => 'Europe/Paris', default_format => 'w3cdtf', );

is( ref $dth, 'DateTimeHandler', 'Object instantiation' );

my $epoch    = 1263475735;
my $dt = $dth->dt_from_epoch( $epoch );
my $date_ref = '2010-01-14T14:28:55+01:00';

my @entries = (
    [ 'default', undef, '2010-01-14 14:28:55', ],
    [ 'iso8601', undef, '20100114T14:28:55', ],
    [ 'twitter', undef, 'Thu Jan 14 14:28:55 +0100 2010', ],
    [ 'w3cdtf', undef, '2010-01-14T14:28:55', '2010-01-14T14:28:55+01:00', ],
    [ 'test', 'le %d %m %Y a %T', 'le 14 01 2010 a 14:28:55', ],
);

foreach my $entry ( @entries ) {
    my ( $format, $pattern, $date, $date_check ) = @$entry;
    $date_check ||= $date;

    $dth->add_parser( $format, $pattern ) if( defined $pattern );

    is( $dth->parse_datetime( $date, $format )->epoch, $epoch, "$format - check parse_datetime" );
    is( $dth->format_datetime( $dt, $format ), $date_check, "$format - check format_datetime" );
    is( $dth->format_epoch( $epoch, $format ), $date_check, "$format - check format_epoch" );
    is( $dth->convert_datetime( $date, $format ), $date_ref, "$format - check convert_datetime from $format to w3cdtf" );
    is( $dth->convert_datetime( $date_ref, undef, $format ), $date_check, "$format - check convert_datetime from w3cdtf to $format" );
}

is( $dth->now->epoch, time, 'check now()');

$dth->auto_time_zone( 0 );
is( $dth->parse_datetime( "2010-01-14T13:28:55", 'w3cdtf' )->epoch, $epoch, "unset auto_time_zone()" );

done_testing;

