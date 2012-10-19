package DateTimeHandler::Role;

# ABSTRACT: Role handling DateTime formats

use Moose::Role;

use DateTimeHandler;

has 'datetime_handler' => (
    isa => 'DateTimeHandler',
    is => 'ro',
    default => sub { DateTimeHandler->new },
    handles => {
        time_zone           => 'time_zone',
        auto_time_zone      => 'auto_time_zone',
        default_dt_format   => 'default_format',
        add_dt_parser       => 'add_parser',
        parse_datetime      => 'parse_datetime',
        format_datetime     => 'format_datetime',
        dt_from_epoch       => 'dt_from_epoch',
        format_epoch        => 'format_epoch',
        convert_datetime    => 'convert_datetime',
        today               => 'today',
        now                 => 'now',
    },
);

no Moose::Role;

1
