package WWW::Google::CustomSearch::Result;

use Moose;
use namespace::clean;

use Data::Dumper;
use WWW::Google::CustomSearch::Request;
use WWW::Google::CustomSearch::Page;
use WWW::Google::CustomSearch::Item;

=head1 NAME

WWW::Google::CustomSearch::Result - Placeholder for Google JSON/Atom Custom Search Result.

=head1 VERSION

Version 0.11

=cut

our $VERSION = '0.11';

has 'api_key' => (is => 'ro', isa => 'Str',     required => 1);
has 'raw'     => (is => 'ro', isa => 'HashRef', required => 1);

has 'kind'                  => (is => 'ro', isa => 'Str');
has 'formattedTotalResults' => (is => 'ro', isa => 'Str');
has 'formattedSearchTime'   => (is => 'ro', isa => 'Str');
has 'totalResults'          => (is => 'ro', isa => 'Str');
has 'searchTime'            => (is => 'ro', isa => 'Str');
has 'url_template'          => (is => 'ro', isa => 'Str');
has 'url_type'              => (is => 'ro', isa => 'Str');
has 'request'               => (is => 'ro', isa => 'WWW::Google::CustomSearch::Request');
has 'nextPage'              => (is => 'ro', isa => 'WWW::Google::CustomSearch::Page');
has 'previousPage'          => (is => 'ro', isa => 'WWW::Google::CustomSearch::Page');
has '_items'                => (is => 'ro', isa => 'ArrayRef[WWW::Google::CustomSearch::Item]');

sub BUILD
{
    my $self = shift;
    my $raw  = $self->raw;

    $self->{'kind'} = $raw->{'kind'};
    $self->{'formattedTotalResults'} = $raw->{'searchInformation'}->{'formattedTotalResults'};
    $self->{'formattedSearchTime'} = $raw->{'searchInformation'}->{'formattedSearchTime'};
    $self->{'totalResults'} = $raw->{'searchInformation'}->{'totalResults'};
    $self->{'searchTime'} = $raw->{'searchInformation'}->{'searchTime'};

    $self->{'url_template'} = $raw->{'url'}->{'template'};
    $self->{'url_type'} = $raw->{'url'}->{'type'};

    $raw->{'queries'}->{'request'}->[0]->{'api_key'} = $self->api_key;
    $self->{'request'} = WWW::Google::CustomSearch::Request->new($raw->{'queries'}->{'request'}->[0]);

    if (defined $raw->{'queries'}->{'nextPage'} && (scalar(@{$raw->{'queries'}->{'nextPage'}}))) {
        $raw->{'queries'}->{'nextPage'}->[0]->{'api_key'} = $self->api_key;
        $self->{'nextPage'} = WWW::Google::CustomSearch::Page->new($raw->{'queries'}->{'nextPage'}->[0]);
    }

    if (defined $raw->{'queries'}->{'previousPage'} && (scalar(@{$raw->{'queries'}->{'previousPage'}}))) {
        $raw->{'queries'}->{'previousPage'}->[0]->{'api_key'} = $self->api_key;
        $self->{'previousPage'} = WWW::Google::CustomSearch::Page->new($raw->{'queries'}->{'previousPage'}->[0]);
    }

    foreach (@{$raw->{items}}) {
        push @{$self->{_items}}, WWW::Google::CustomSearch::Item->new($_);
    }
}

=head1 DESCRIPTION

Provides the interface to the individual search results based on the search criteria.

=head1 METHODS

=head2 kind()

Returns the 'kind' attribute of the search result.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx);
    my $result  = $engine->search("Google");
    print "Kind: ", $result->kind, "\n";

=head2 formattedTotalResults()

Returns the 'formattedTotalResults' attribute of the search result.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx);
    my $result  = $engine->search("Google");
    print "Formatted Total Results: ", $result->formattedTotalResults, "\n";

=head2 formattedSearchTime()

Returns the 'formattedSearchTime' attribute of the search result.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx);
    my $result  = $engine->search("Google");
    print "Formatted Search Time: ", $result->formattedSearchTime, "\n";

=head2 totalResults()

Returns the 'totalResults' attribute of the search result.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx);
    my $result  = $engine->search("Google");
    print "Total Results: ", $result->totalResults, "\n";

=head2 searchTime()

Returns the 'searchTime' attribute of the search result.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx);
    my $result  = $engine->search("Google");
    print "Search Time: ", $result->searchTime, "\n";

=head2 url_template()

Returns the URL template attribute of the search result.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx);
    my $result  = $engine->search("Google");
    print "URL Template: ", $result->url_template, "\n";

=head2 url_type()

Returns the URL Type attribute of the search result.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx);
    my $result  = $engine->search("Google");
    print "URL Type: ", $result->url_type, "\n";

=head2 request()

Returns the request L<WWW::Google::CustomSearch::Request> object used in the last search.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx);
    my $result  = $engine->search("Google");
    my $request = $result->request;

=head2 nextPage()

Returns the next page L<WWW::Google::CustomSearch::Page> object which can be used to fetch the
next page result.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx);
    my $result  = $engine->search("Google");
    my $page    = $result->nextPage;

=head2 previousPage()

Returns the previous page L<WWW::Google::CustomSearch::Page> object which can be used to fetch
the previous page result.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx, start => 2);
    my $result  = $engine->search("Google");
    my $page    = $result->previousPage;

=head2 items()

Returns list of search item L<WWW::Google::CustomSearch::Item> based on the search criteria.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key => $api_key, cx => $cx);
    my $result  = $engine->search("Google");
    my $items   = $result->items; # ArrayRef
    my @items   = $result->items; # Array

=cut

sub items {
    my $self = shift;
    return unless defined $self->{_items};
    return @{$self->{_items}} if wantarray;
    return $self->{_items};
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

    perldoc WWW::Google::CustomSearch::Result

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
no Moose; # Keywords are removed from the WWW::Google::CustomSearch::Result package

1; # End of WWW::Google::CustomSearch::Result