This class provides an easy interface to:
   * handle DateTime conversion in multiple formats;
   * ensure that the same time_zone is set in all the DateTime objects.

The package contains a DateTimeHandler class and a Moose role DateTimeHandler::Role wich provides accessors to all the methods of the class.

Create a DateTimeHandler object:
<code perl>
use DateTimeHandler;

my $dth = DateTimeHandler->new;
</code>

You can specify the default format of date and the time zone of the DateTime objects returned:
<code perl>
  my $dth = DateTimeHandler->new(
    default_format => 'w3cdtf',
    time_zone      => 'Europe/Paris',
  );                                      # same as DateTimeHandler->new;
</code>


Get a DateTime object from a string in a given format:
<code perl>
  my $dt = $dth->parse_datetime( '2010-02-16T17:26:47', 'w3cdtf' ); # string in w3cdtf format
</code>

You can specify a default format. The default format is set to 'w3cdtf' by default and is always used when the format param is missing:
<code perl>
  $dth->default_format('w3cdtf');
  my $dt = $dth->parse_datetime( '2010-02-16T17:26:47' ); # string in w3cdtf format
</code>

Format a DateTime object to a string format:
<code perl>
  my $string = $dth->format_datetime( $dt, 'w3cdtf' );
</code>
or
<code perl>
  my $string = $dth->format_datetime( $dt );
</code>

To convert a string in a given format to an other format:
<code perl>
  my $string = $dth->convert_datetime( '2010-05-08T12:14:00', 'w3cdtf', 'default' ); # $string = '2010-05-08 12:14:00'
</code>

Get a DateTime from an epoch.The correct time zone is set for the DateTime object returned:
<code perl>
  my $dt = $dth->dt_from_epoch( 1279663200 );
</code>

Get a string from an epoch in a given format:
<code perl>
  my $string = $dth->format_epoch( 1279663200, 'w3cdtf' ); # $string = '2010-07-21T00:00:00+02:00';
</code>

Get a DateTime object set to current time:
<code perl>
  my $now = $dth->now;
</code>

Get a DateTime object set to current date:
<code perl>
  my $today = $dth->today;
</code>

Patterns currently known: 
  * format, pattern, example
  * w3cdtf, W3CDTF, '2010-07-21T00:00:00+02:00'
  * default, "%F %T",  '2010-01-14 14:28:55'
  * iso8601, "%Y%m%dT%T", '20100114T14:28:55'
  * twitter, "%a %b %d %T %z %Y", "Thu Jan 14 14:28:55 +0100 2010"

To add a format:
<code perl>
  $dth->add_parser( 'my_format_name', 'my_format_pattern' );
</code>
