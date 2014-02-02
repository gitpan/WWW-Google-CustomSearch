package WWW::Google::CustomSearch::Item;

use Moose;
use namespace::clean;

use Data::Dumper;

=head1 NAME

WWW::Google::CustomSearch::Item - Placeholder for Google JSON/Atom Custom Search Item.

=head1 VERSION

Version 0.10

=cut

our $VERSION = '0.10';

has 'kind'             => (is => 'ro', isa => 'Str');
has 'link'             => (is => 'ro', isa => 'Str');
has 'displayLink'      => (is => 'ro', isa => 'Str');
has 'snippet'          => (is => 'ro', isa => 'Str');
has 'htmlSnippet'      => (is => 'ro', isa => 'Str');
has 'cacheId'          => (is => 'ro', isa => 'Str');
has 'formattedUrl'     => (is => 'ro', isa => 'Str');
has 'htmlFormattedUrl' => (is => 'ro', isa => 'Str');
has 'title'            => (is => 'ro', isa => 'Str');
has 'htmlTitle'        => (is => 'ro', isa => 'Str');

=head1 DESCRIPTION

=head1 METHODS

=head2 kind()

Returns the 'kind' attribute of the search.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx);
    my $result  = $engine->search("Google");
    foreach my $item ($result->items) {
        print "Item Kind: ", $item->kind, "\n" if defined $item->kind;
    }

=head2 link()

Returns the 'link' attribute of the search.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx);
    my $result  = $engine->search("Google");
    foreach my $item ($result->items) {
        print "Item Link: ", $item->link, "\n" if defined $item->link;
    }

=head2 displayLink()

Returns the 'displayLink' attribute of the search.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx);
    my $result  = $engine->search("Google");
    foreach my $item ($result->items) {
        print "Item Display Link: ", $item->displayLink, "\n" if defined $item->displayLink;
    }

=head2 snippet()

Returns the 'snippet' attribute of the search.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx);
    my $result  = $engine->search("Google");
    foreach my $item ($result->items) {
        print "Item Snippet: ", $item->snippet, "\n" if defined $item->snippet;
    }

=head2 htmlSnippet()

Returns the 'htmlSnippet' attribute of the search.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx);
    my $result  = $engine->search("Google");
    foreach my $item ($result->items) {
        print "Item HTML Snippet: ", $item->htmlSnippet, "\n" if defined $item->htmlSnippet;
    }

=head2 cacheId()

Returns the 'cacheId' attribute of the search.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx);
    my $result  = $engine->search("Google");
    foreach my $item ($result->items) {
        print "Item Cache Id: ", $item->cacheId, "\n" if defined $item->cacheId;
    }

=head2 formattedUrl()

Returns the 'formattedUrl' attribute of the search.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx);
    my $result  = $engine->search("Google");
    foreach my $item ($result->items) {
        print "Item Formatted URL: ", $item->formattedUrl, "\n" if defined $item->formattedUrl;
    }

=head2 htmlFormattedUrl()

Returns the 'htmlFormattedUrl' attribute of the search.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx);
    my $result  = $engine->search("Google");
    foreach my $item ($result->items) {
        print "Item HTML Formatted URL: ", $item->htmlFormattedUrl, "\n" if defined $item->htmlFormattedUrl;
    }

=head2 title()

Returns the 'title' attribute of the search.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx);
    my $result  = $engine->search("Google");
    foreach my $item ($result->items) {
        print "Item Title: ", $item->title, "\n" if defined $item->title;
    }

=head2 htmlTitle()

Returns the 'htmlTitle' attribute of the search.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx);
    my $result  = $engine->search("Google");
    foreach my $item ($result->items) {
        print "Item HTML Title: ", $item->htmlTitle, "\n" if defined $item->htmlTitle;
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

    perldoc WWW::Google::CustomSearch::Item

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
no Moose; # Keywords are removed from the WWW::Google::CustomSearch::Item package

1; # End of WWW::Google::CustomSearch::Item