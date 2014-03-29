package Geo::Coder::All;
#use Modern::Perl;
use Moose;
use Geo::Coder::All::Google;
use Geo::Coder::All::OSM;
use Geo::Coder::All::TomTom;
use Geo::Coder::All::Ovi;
use Geo::Coder::All::Bing;
use URI::Escape;
use Data::Dumper;
#use Geo::Coder::Osm;
my %VALID_GEOCODER_LIST = map { $_ => 1} qw(
    Google
    OSM
    TomTom
    Ovi
    Bing
);
has 'geocoder' => (is=>'rw',isa=>'Str','default'=> 'Google');
has 'key' => (is=>'rw',isa=>'Str','default'=> '',reader=>'get_key');

has 'langauge' => (is=>'rw',isa=>'Str',init_arg=>'language',default=>'en',reader=>'get_language');
has 'google_apiver' => (is=>'rw',isa=>'Num',init_arg=>'apiver',default=>3,reader=>'get_google_apiver');

has 'geocoder_engine' => (
    is  => 'rw',
    init_arg => undef,
    lazy => 1,
    isa => 'Object',
    builder => '_build_geocoder_engine',
    handles =>{
        geocode => 'geocode_local'
        } 
    );

sub _build_geocoder_engine {
    my $self        = shift;
    my $geocoder    = $self->geocoder;
    
    unless($VALID_GEOCODER_LIST{$geocoder}){
        $geocoder = 'Google';
        $self->geocoder('Google');
    }
    
    my $class = 'Geo::Coder::All::'.$geocoder;
    return $class->new(); 
}

around 'geocode' => sub{
    my ($orig,$class,$rh_args) =  @_;
    $rh_args->{key}= $class->get_key if($class->get_key);
    $rh_args->{language}= $class->get_language if($class->get_language);
    $rh_args->{google_apiver}= $class->get_google_apiver if($class->geocoder eq 'Google');
    return $class->$orig($rh_args);
};
=head1 NAME

Geo::Coder::All - The great new Geo::Coder::All!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Geo::Coder::All;

    my $foo = Geo::Coder::All->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 function1

=cut

=head2 function2

=cut


=head1 AUTHOR

Rohit Deshmukh, C<< <raigad1630 at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-geo-coder-all at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Geo-Coder-All>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Geo::Coder::All


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Geo-Coder-All>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Geo-Coder-All>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Geo-Coder-All>

=item * Search CPAN

L<http://search.cpan.org/dist/Geo-Coder-All/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2014 Rohit Deshmukh.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of Geo::Coder::All
