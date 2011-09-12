package WWW::Google::CustomSearch;

use Moose;
use MooseX::Params::Validate;
use Moose::Util::TypeConstraints;
use namespace::clean;

use Carp;
use Data::Dumper;

use JSON;
use Readonly;
use HTTP::Request;
use LWP::UserAgent;

Readonly my $LANGUAGE =>
{
    'lang_ar'    => 1,
    'lang_bg'    => 1,
    'lang_ca'    => 1,
    'lang_zh-cn' => 1,
    'lang_zh-tw' => 1,
    'lang_hr'    => 1,
    'lang_cs'    => 1,
    'lang_da'    => 1,
    'lang_nl'    => 1,
    'lang_en'    => 1,
    'lang_et'    => 1,
    'lang_fi'    => 1,
    'lang_fr'    => 1,
    'lang_de'    => 1,
    'lang_el'    => 1,
    'lang_iw'    => 1,
    'lang_hu'    => 1,
    'lang_is'    => 1,
    'lang_id'    => 1,
    'lang_it'    => 1,
    'lang_ja'    => 1,
    'lang_ko'    => 1,
    'lang_lv'    => 1,
    'lang_lt'    => 1,
    'lang_no'    => 1,
    'lang_pl'    => 1,
    'lang_pt'    => 1,
    'lang_ro'    => 1,
    'lang_ru'    => 1,
    'lang_sr'    => 1,
    'lang_sk'    => 1,
    'lang_sl'    => 1,
    'lang_es'    => 1,
    'lang_sv'    => 1,
    'lang_tr'    => 1
};

=head1 NAME

WWW::Google::CustomSearch - Interface to Google JSON/Atom Custom Search.

=head1 VERSION

Version 0.04

=cut

our $VERSION = '0.04';
Readonly my $API_VERSION => 'v1';
Readonly my $BASE_URL    => "https://www.googleapis.com/customsearch/$API_VERSION";

=head1 DESCRIPTION

This module is intended for anyone who wants to write applications that can interact with  the
JSON/Atom Custom Search API. With Google Custom Search, you can harness the power of Google to
create a  customized  search experience for your own website. You can use the JSON/Atom Custom 
Search API to retrieve Google Custom Search results programmatically.

The  JSON / Atom Custom Search API  requires the use of an API key, which you can get from the 
Google APIs  console.  The API provides 100 search queries per day for free. If you need more,
you may sign up for billing in the console. 

Important:The version v1 of the Google JSON/Atom Custom Search API is in Labs and its features 
might change unexpectedly until it graduates.

=head1 LANGUAGES (lr)

    +----------------------+------------+
    | Language             | Value      |
    +----------------------+------------+
    | Arabic               | lang_ar    | 
    | Bulgarian            | lang_bg    |
    | Catalan              | lang_ca    |
    | Chinese (Simplified) | lang_zh-CN |
    | Chinese (Traditional)| lang_zh-TW |
    | Croatian             | lang_hr    |
    | Czech                | lang_cs    |
    | Danish               | lang_da    |
    | Dutch                | lang_nl    |
    | English              | lang_en    |
    | Estonian             | lang_et    |
    | Finnish              | lang_fi    |
    | French               | lang_fr    |
    | German               | lang_de    |
    | Greek                | lang_el    |
    | Hebrew               | lang_iw    |
    | Hungarian            | lang_hu    |
    | Icelandic            | lang_is    |
    | Indonesian           | lang_id    |
    | Italian              | lang_it    |
    | Japanese             | lang_ja    |
    | Korean               | lang_ko    | 
    | Latvian              | lang_lv    |
    | Lithuanian           | lang_lt    |
    | Norwegian            | lang_no    |
    | Polish               | lang_pl    |
    | Portuguese           | lang_pt    |
    | Romanian             | lang_ro    |
    | Russian              | lang_ru    |
    | Serbian              | lang_sr    |
    | Slovak               | lang_sk    |
    | Slovenian            | lang_sl    |
    | Spanish              | lang_es    |
    | Swedish              | lang_sv    |
    | Turkish              | lang_tr    |
    +----------------------+------------+

=head1 CONSTRUCTOR

The constructor expects your application API Key & Custom search engine identifier. Use either
cx  or  cref  to specify the custom search engine you want to perform this search. If both are 
specified, cx is used.

    +-------------+------------------------------------------------------------------+
    | Key         | Description                                                      |
    +-------------+------------------------------------------------------------------+
    | api_key     | Your application API Key.                                        | 
    |             |                                                                  |
    | alt         | Alternative data representation format. If you don't specify an  |
    |             | alt parameter, the API returns data in the JSON format. This is  |
    |             | equivalent to alt=json. Accepted values are json and atom.       |
    |             |                                                                  |
    | cx          | For a search engine created with the Google Custom Search page.  |
    |             |                                                                  |
    | cref        | For a linked custom search engine.                               |
    |             |                                                                  |
    | lr          | The language restriction for the search results.                 |
    |             |                                                                  |
    | num         | Number of search results to return. Valid values are integers    |
    |             | between 1 and 10, Default is 10.                                 |
    |             |                                                                  |
    | prettyprint | Returns a response with indentations and line breaks.            |  
    |             | If prettyprint=true, the results returned by the server will be  |
    |             | human readable (pretty printed).                                 |
    |             |                                                                  |
    | safe        | Search safety level. Default is off. Possible values are:        |
    |             | * high - enables highest level of safe search filtering.         |
    |             | * medium - enables moderate safe search filtering.               |
    |             | * off - disables safe search filtering.                          |
    |             |                                                                  |
    | start       | The index of the first result to return.Valid values are between |
    |             | 1 and 91. Default is 1.                                          |
    |             |                                                                  |
    | filter      | Controls turning on or off the duplicate content filter.         |
    |             | * filter=0 - Turns off the duplicate content filter.             |
    |             | * filter=1 - Turns on the duplicate content filter (default).    |  
    +-------------+------------------------------------------------------------------+

=cut

type 'Language'     => where { exists($LANGUAGE->{lc($_)}) };
type 'ZeroOrOne'    => where { (/^[1|0]$/) }; 
type 'StartIndex'   => where { (/^\d{1,2}$/) && ($_>=1) && ($_<=91) }; 
type 'ResultCount'  => where { (/^\d{1,2}$/) && ($_>=1) && ($_<=10) }; 
type 'SafetyLevel'  => where { /\bhigh\b|\bmedium\b|\boff\b/i };
type 'OutputFormat' => where { /\bjson\b|\batom\b/i  };
type 'TrueFalse'    => where { /\btrue\b|\bfalse\b/i };
has  'api_key'      => (is => 'ro', isa => 'Str', required => 1);
has  'cx'           => (is => 'ro', isa => 'Str');
has  'cref'         => (is => 'ro', isa => 'Str');
has  'prettyprint'  => (is => 'ro', isa => 'TrueFalse');
has  'alt'          => (is => 'ro', isa => 'OutputFormat');
has  'lr'           => (is => 'ro', isa => 'Language');
has  'num'          => (is => 'ro', isa => 'ResultCount');
has  'start'        => (is => 'ro', isa => 'StartIndex');
has  'safe'         => (is => 'ro', isa => 'SafetyLevel');
has  'filter'       => (is => 'ro', isa => 'ZeroOrOne');
has  'browser'      => (is => 'rw', isa => 'LWP::UserAgent', default => sub { return LWP::UserAgent->new(); });

around BUILDARGS => sub
{
    my $orig  = shift;
    my $class = shift;

    if (@_ == 1 && ! ref $_[0])
    {
        return $class->$orig(api_key => $_[0]);
    }
    elsif (@_ == 2 && ! ref $_[0])
    {
        return $class->$orig(api_key => $_[0], cx => $_[1]);
    }
    else
    {
        return $class->$orig(@_);
    }
};

sub BUILD 
{
  my $self = shift;
  croak("ERROR: cx or cref must be specified.\n")
    unless ($self->cx || $self->cref);
}

=head1 METHODS

=head2 search()

Get search result for the given query.

    use strict; use warnings;
    use Data::Dumper;
    use WWW::Google::CustomSearch;
    
    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new($api_key, $cx);
    print Dumper($engine->search('Google'));

=cut

sub search
{
    my $self    = shift;
    my ($query) = pos_validated_list(\@_,
                  { isa => 'Str', required => 1 },
                  MX_PARAMS_VALIDATE_NO_CACHE => 1);
                  
    my ($browser, $url, $request, $response, $content);
    $browser  = $self->browser;
    $url      = sprintf("%s?key=%s", $BASE_URL, $self->api_key);
    if (($self->cx) || ($self->cx && $self->cref))
    {
        $url .= sprintf("&cx=%s", $self->cx);
    }
    elsif ($self->cref)
    {
        $url .= sprintf("&cref=%s", $self->cref);
    }
    $url .= sprintf("&prettyprint=%s", $self->prettyprint) if $self->prettyprint;
    $url .= sprintf("&alt=%s",    $self->alt)    if $self->alt;
    $url .= sprintf("&lr=%s",     $self->lr)     if $self->lr;
    $url .= sprintf("&safe=%s",   $self->safe)   if $self->safe;
    $url .= sprintf("&num=%d",    $self->num)    if $self->num;
    $url .= sprintf("&start=%d",  $self->start)  if $self->start;
    $url .= sprintf("&filter=%d", $self->filter) if $self->filter;
    $url .= sprintf("&q=%s",      $query);
    
    $request  = HTTP::Request->new(GET => $url);
    $response = $browser->request($request);
    croak("ERROR: Couldn't fetch data [$url]:[".$response->status_line."]\n")
        unless $response->is_success;
    $content  = $response->content;
    croak("ERROR: No data found.\n") unless defined $content;
    return from_json($content) if ($self->alt =~ /json/i);                  
    return $content;
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

    perldoc WWW::Google::CustomSearch

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
no Moose; # Keywords are removed from the WWW::Google::CustomSearch package
#no Moose::Util::TypeConstraints;

1; # End of WWW::Google::CustomSearch