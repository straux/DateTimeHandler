package DateTimeHandler;

# ABSTRACT: Object Handling DateTime formats

use Moose;

use DateTime::Format::Strptime;
use DateTime::Format::W3CDTF;
use DateTime;

has 'datetime_parser' => (
    isa => 'HashRef',
    is => 'ro',
    default => sub { {} },
);

has 'patterns' => (
    isa => 'HashRef',
    is => 'ro',
    default => sub { {
            'default' => '%F %T',
            'iso8601' => '%Y%m%dT%T',
            'twitter' => '%a %b %d %T %z %Y',
            'w3cdtf'  => 'w3cdtf',
            'ymd'     => '%Y%m%d'
        } },
);

has 'time_zone' => ( isa => 'Str', is => 'rw', default => 'Europe/Paris' );
has 'auto_time_zone' => ( isa => 'Int', is => 'rw', default => 1 );
has 'default_format' => ( isa => 'Str', is => 'rw', default => 'w3cdtf' );

sub date_parser {
    my ( $pattern ) = @_;

    my $dtp = undef;
    if( $pattern eq 'w3cdtf' ) {
        $dtp = DateTime::Format::W3CDTF->new();
    } else {
        $dtp = DateTime::Format::Strptime->new( pattern => $pattern );
    }
    $dtp;
}

sub add_parser {
    my ( $self, $format, $pattern ) = @_;

    if( !defined $pattern ) {
        die "No pattern known for format '$format'.\n" unless( defined $self->patterns->{ $format } );
        $pattern = $self->patterns->{ $format };
    }

    $self->datetime_parser->{ $format } = date_parser( $pattern );
    $self->datetime_parser->{ $format };
}

sub get_parser {
    my ( $self, $format ) = @_;
    $format ||= $self->default_format;

    defined $self->datetime_parser->{ $format } ?
       $self->datetime_parser->{ $format } : $self->add_parser( $format );
}

sub parse_datetime {
    my ( $self, $datetime, $format ) = @_;

    $self->coerce_time_zone( $self->get_parser( $format )->parse_datetime( $datetime ) );
}

sub format_datetime {
    my ( $self, $datetime, $format ) = @_;

    $datetime = $self->coerce_time_zone( $datetime );
    $self->get_parser( $format )->format_datetime( $datetime );
}

sub dt_from_epoch {
    my ( $self, $epoch ) = @_;

    $self->coerce_time_zone( DateTime->from_epoch( epoch => $epoch ) );
}

sub format_epoch {
    my ( $self, $epoch, $format ) = @_;

    $self->get_parser( $format )->format_datetime( $self->dt_from_epoch( $epoch ) );
}

sub convert_datetime {
    my ( $self, $datetime, $init_format, $convert_format ) = @_;

    my $dt = $self->parse_datetime( $datetime, $init_format );
    $self->format_datetime( $dt, $convert_format );
}

sub today {
    my ( $self ) = @_;

    $self->coerce_time_zone( DateTime->now )->truncate( to => 'day' );
}

sub now {
    my ( $self ) = @_;

    $self->coerce_time_zone( DateTime->now );
}

sub coerce_time_zone {
    my ( $self, $dt ) = @_;
    $self->auto_time_zone ? $dt->set_time_zone( $self->time_zone ) : $dt;
}

no Moose;

1
