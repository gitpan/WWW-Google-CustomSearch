package WWW::Google::CustomSearch::Request;

use Moose;
use namespace::clean;

use Data::Dumper;
use WWW::Google::CustomSearch::Page;

=head1 NAME

WWW::Google::CustomSearch::Request - Placeholder for Google JSON/Atom Custom Search Request.

=head1 VERSION

Version 0.08

=cut

our $VERSION = '0.08';
has 'page'    => (is => 'ro', isa => 'WWW::Google::CustomSearch::Page');
has 'api_key' => (is => 'ro', isa => 'Str', required => 1);

sub BUILD
{
    my $self = shift;
    my $args = shift;
    $args->{'api_key'} = $self->api_key;
    $self->{page} = WWW::Google::CustomSearch::Page->new($args);
}

=head1 DESCRIPTION

Provides the interface to the search request used last time.

=head1 METHOD

=head2 fetch()

Returns the L<WWW::Google::CustomSearch::Result> object base on the criteria used in the  last
search.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx);
    my $result  = $engine->search("Google");
    my $page    = $result->request;
    my $another = $page->fetch;

=cut

sub fetch {
    my $self = shift;
    return $self->{page}->fetch;
}

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=head1 BUGS

Please report  any  bugs or feature requests to C<bug-www-google-customsearch at rt.cpan.org>,
or through the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-Google-CustomSearch>.
I will be notified and then you'll automatically be notified of progress on your bug as I make
changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::Google::CustomSearch::Request

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-Google-CustomSearch>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-Google-CustomSearch>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-Google-CustomSearch>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-Google-CustomSearch/>

=back

=head1 LICENSE AND COPYRIGHT

This  program  is  free  software; you can redistribute it and/or modify it under the terms of
either:  the  GNU  General Public License as published by the Free Software Foundation; or the
Artistic License.

See http://dev.perl.org/licenses/ for more information.

=head1 DISCLAIMER

This  program  is  distributed  in  the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=cut

__PACKAGE__->meta->make_immutable;
no Moose; # Keywords are removed from the WWW::Google::CustomSearch::Request package

1; # End of WWW::Google::CustomSearch::Request