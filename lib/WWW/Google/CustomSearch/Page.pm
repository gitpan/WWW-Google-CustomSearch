package WWW::Google::CustomSearch::Page;

use Moose;
use namespace::clean;

use Data::Dumper;
use Moose::Util::TypeConstraints;
use WWW::Google::CustomSearch;

=head1 NAME

WWW::Google::CustomSearch::Page - Placeholder for Google JSON/Atom Custom Search Page.

=head1 VERSION

Version 0.10

=cut

our $VERSION = '0.10';

type 'SafetyLevel'    => where { /\bhigh\b|\bmedium\b|\boff\b/i };
has  'api_key'        => (is => 'ro', isa => 'Str', required => 1);
has  'cx'             => (is => 'ro', isa => 'Str', required => 1);
has  'safe'           => (is => 'ro', isa => 'SafetyLevel', default => 'off');
has  'count'          => (is => 'ro', isa => 'Num');
has  'searchTerms'    => (is => 'ro', isa => 'Str', required => 1);
has  'inputEncoding'  => (is => 'ro', isa => 'Str', required => 1);
has  'startIndex'     => (is => 'ro', isa => 'Num', default  => 1);
has  'title'          => (is => 'ro', isa => 'Str', required => 1);
has  'totalResults'   => (is => 'ro', isa => 'Num', required => 1);
has  'outputEncoding' => (is => 'ro', isa => 'Str', required => 1);

=head1 DESCRIPTION

Provides the interface to the individual search page based on the search criteria.

=head1 METHODS

=head2 safe()

Returns the safety level of the search.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx);
    my $result  = $engine->search("Google");
    my $page    = $result->nextPage;
    print "Safety Level: ", $page->safe, "\n";

=head2 count()

Returns the 'count' attribute of the search.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx);
    my $result  = $engine->search("Google");
    my $page    = $result->nextPage;
    print "Page count: ", $page->count, "\n";

=head2 searchTerms()

Returns the 'searchTerms' attribute of the search.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx);
    my $result  = $engine->search("Google");
    my $page    = $result->nextPage;
    print "Search Terms: ", $page->searchTerms, "\n";

=head2 startIndex()

Returns the 'startIndex' attribute of the search.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx);
    my $result  = $engine->search("Google");
    my $page    = $result->nextPage;
    print "Start Index: ", $page->startIndex, "\n";

=head2 title()

Returns the 'title' attribute of the search.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx);
    my $result  = $engine->search("Google");
    my $page    = $result->nextPage;
    print "Title: ", $page->title, "\n";

=head2 totalResults()

Returns the 'totalResults' attribute of the search.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx);
    my $result  = $engine->search("Google");
    my $page    = $result->nextPage;
    print "Total Results: ", $page->totalResults, "\n";

=head2 inputEncoding()

Returns the 'inputEncoding' attribute of the search.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx);
    my $result  = $engine->search("Google");
    my $page    = $result->nextPage;
    print "Input Encoding: ", $page->inputEncoding, "\n";

=head2 outputEncoding()

Returns the 'outputEncoding' attribute of the search.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx);
    my $result  = $engine->search("Google");
    my $page    = $result->nextPage;
    print "Output Encoding: ", $page->outputEncoding, "\n";

=head2 fetch()

Perform a fresh search based on the previous input data and returns L<WWW::Google::CustomSearch::Result>
object.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx);
    my $result  = $engine->search("Google");
    my $page    = $result->nextPage;
    my $next    = $page->fetch;

=cut

sub fetch {
    my $self   = shift;
    my $engine = WWW::Google::CustomSearch->new({ api_key => $self->api_key,
                                                  cx      => $self->cx,
                                                  start   => $self->startIndex });
    return $engine->search($self->searchTerms);
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

    perldoc WWW::Google::CustomSearch::Page

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
no Moose; # Keywords are removed from the WWW::Google::CustomSearch::Page package

1; # End of WWW::Google::CustomSearch::Page