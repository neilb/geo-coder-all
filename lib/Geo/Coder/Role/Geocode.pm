package Geo::Coder::Role::Geocode;
use Moose::Role;
use HTTP::Tiny;
use Carp;
use Data::Dumper;

requires 'geocode_local';

has 'ua' =>(
    is          => 'ro',
    'default'   => sub {HTTP::Tiny->new(agent=> 'Geo::Coder::All');}
);

sub get {
    my $self = shift;
    my $uri = shift;
    my $response = $self->ua->get($uri);
    #TODO: add actual error message from uri
    croak "Request Failed" unless $response->{success};
    return $response->{content};
}
1;

