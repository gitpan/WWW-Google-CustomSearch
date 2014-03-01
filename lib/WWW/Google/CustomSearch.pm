package WWW::Google::CustomSearch;

use Moose;
use MooseX::Params::Validate;
use Moose::Util::TypeConstraints;
use namespace::clean;

use Carp;
use Data::Dumper;
use WWW::Google::CustomSearch::Result;

use JSON;
use XML::Simple;
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

Readonly my $COUNTRY_COLLECTION =>
{
    'countryaf' => 1,
    'countryal' => 1,
    'countrydz' => 1,
    'countryas' => 1,
    'countryad' => 1,
    'countryao' => 1,
    'countryai' => 1,
    'countryaq' => 1,
    'countryag' => 1,
    'countryar' => 1,
    'countryam' => 1,
    'countryaw' => 1,
    'countryau' => 1,
    'countryat' => 1,
    'countryaz' => 1,
    'countrybs' => 1,
    'countrybh' => 1,
    'countrybd' => 1,
    'countrybb' => 1,
    'countryby' => 1,
    'countrybe' => 1,
    'countrybz' => 1,
    'countrybj' => 1,
    'countrybm' => 1,
    'countrybt' => 1,
    'countrybo' => 1,
    'countryba' => 1,
    'countrybw' => 1,
    'countrybv' => 1,
    'countrybr' => 1,
    'countryio' => 1,
    'countrybn' => 1,
    'countrybg' => 1,
    'countrybf' => 1,
    'countrybi' => 1,
    'countrykh' => 1,
    'countrycm' => 1,
    'countryca' => 1,
    'countrycv' => 1,
    'countryky' => 1,
    'countrycf' => 1,
    'countrytd' => 1,
    'countrycl' => 1,
    'countrycn' => 1,
    'countrycx' => 1,
    'countrycc' => 1,
    'countryco' => 1,
    'countrykm' => 1,
    'countrycg' => 1,
    'countrycd' => 1,
    'countryck' => 1,
    'countrycr' => 1,
    'countryci' => 1,
    'countryhr' => 1,
    'countrycu' => 1,
    'countrycy' => 1,
    'countrycz' => 1,
    'countrydk' => 1,
    'countrydj' => 1,
    'countrydm' => 1,
    'countrydo' => 1,
    'countrytp' => 1,
    'countryec' => 1,
    'countryeg' => 1,
    'countrysv' => 1,
    'countrygq' => 1,
    'countryer' => 1,
    'countryee' => 1,
    'countryet' => 1,
    'countryeu' => 1,
    'countryfk' => 1,
    'countryfo' => 1,
    'countryfj' => 1,
    'countryfi' => 1,
    'countryfr' => 1,
    'countryfx' => 1,
    'countrygf' => 1,
    'countrypf' => 1,
    'countrytf' => 1,
    'countryga' => 1,
    'countrygm' => 1,
    'countryge' => 1,
    'countryde' => 1,
    'countrygh' => 1,
    'countrygi' => 1,
    'countrygr' => 1,
    'countrygl' => 1,
    'countrygd' => 1,
    'countrygp' => 1,
    'countrygu' => 1,
    'countrygt' => 1,
    'countrygn' => 1,
    'countrygw' => 1,
    'countrygy' => 1,
    'countryht' => 1,
    'countryhm' => 1,
    'countryva' => 1,
    'countryhn' => 1,
    'countryhk' => 1,
    'countryhu' => 1,
    'countryis' => 1,
    'countryin' => 1,
    'countryid' => 1,
    'countryir' => 1,
    'countryiq' => 1,
    'countryie' => 1,
    'countryil' => 1,
    'countryit' => 1,
    'countryjm' => 1,
    'countryjp' => 1,
    'countryjo' => 1,
    'countrykz' => 1,
    'countryke' => 1,
    'countryki' => 1,
    'countrykp' => 1,
    'countrykr' => 1,
    'countrykw' => 1,
    'countrykg' => 1,
    'countryla' => 1,
    'countrylv' => 1,
    'countrylb' => 1,
    'countryls' => 1,
    'countrylr' => 1,
    'countryly' => 1,
    'countryli' => 1,
    'countrylt' => 1,
    'countrylu' => 1,
    'countrymo' => 1,
    'countrymk' => 1,
    'countrymg' => 1,
    'countrymw' => 1,
    'countrymy' => 1,
    'countrymv' => 1,
    'countryml' => 1,
    'countrymt' => 1,
    'countrymh' => 1,
    'countrymq' => 1,
    'countrymr' => 1,
    'countrymu' => 1,
    'countryyt' => 1,
    'countrymx' => 1,
    'countryfm' => 1,
    'countrymd' => 1,
    'countrymc' => 1,
    'countrymn' => 1,
    'countryms' => 1,
    'countryma' => 1,
    'countrymz' => 1,
    'countrymm' => 1,
    'countryna' => 1,
    'countrynr' => 1,
    'countrynp' => 1,
    'countrynl' => 1,
    'countryan' => 1,
    'countrync' => 1,
    'countrynz' => 1,
    'countryni' => 1,
    'countryne' => 1,
    'countryng' => 1,
    'countrynu' => 1,
    'countrynf' => 1,
    'countrymp' => 1,
    'countryno' => 1,
    'countryom' => 1,
    'countrypk' => 1,
    'countrypw' => 1,
    'countryps' => 1,
    'countrypa' => 1,
    'countrypg' => 1,
    'countrypy' => 1,
    'countrype' => 1,
    'countryph' => 1,
    'countrypn' => 1,
    'countrypl' => 1,
    'countrypt' => 1,
    'countrypr' => 1,
    'countryqa' => 1,
    'countryre' => 1,
    'countryro' => 1,
    'countryru' => 1,
    'countryrw' => 1,
    'countrysh' => 1,
    'countrykn' => 1,
    'countrylc' => 1,
    'countrypm' => 1,
    'countryvc' => 1,
    'countryws' => 1,
    'countrysm' => 1,
    'countryst' => 1,
    'countrysa' => 1,
    'countrysn' => 1,
    'countrycs' => 1,
    'countrysc' => 1,
    'countrysl' => 1,
    'countrysg' => 1,
    'countrysk' => 1,
    'countrysi' => 1,
    'countrysb' => 1,
    'countryso' => 1,
    'countryza' => 1,
    'countrygs' => 1,
    'countryes' => 1,
    'countrylk' => 1,
    'countrysd' => 1,
    'countrysr' => 1,
    'countrysj' => 1,
    'countrysz' => 1,
    'countryse' => 1,
    'countrych' => 1,
    'countrysy' => 1,
    'countrytw' => 1,
    'countrytj' => 1,
    'countrytz' => 1,
    'countryth' => 1,
    'countrytg' => 1,
    'countrytk' => 1,
    'countryto' => 1,
    'countrytt' => 1,
    'countrytn' => 1,
    'countrytr' => 1,
    'countrytm' => 1,
    'countrytc' => 1,
    'countrytv' => 1,
    'countryug' => 1,
    'countryua' => 1,
    'countryae' => 1,
    'countryuk' => 1,
    'countryus' => 1,
    'countryum' => 1,
    'countryuy' => 1,
    'countryuz' => 1,
    'countryvu' => 1,
    'countryve' => 1,
    'countryvn' => 1,
    'countryvg' => 1,
    'countryvi' => 1,
    'countrywf' => 1,
    'countryeh' => 1,
    'countryye' => 1,
    'countryyu' => 1,
    'countryzm' => 1,
    'countryzw' => 1
};

Readonly my $COUNTRY_CODE =>
{
    'af' => 1,
    'al' => 1,
    'dz' => 1,
    'as' => 1,
    'ad' => 1,
    'ao' => 1,
    'ai' => 1,
    'aq' => 1,
    'ag' => 1,
    'ar' => 1,
    'am' => 1,
    'aw' => 1,
    'au' => 1,
    'at' => 1,
    'az' => 1,
    'bs' => 1,
    'bh' => 1,
    'bd' => 1,
    'bb' => 1,
    'by' => 1,
    'be' => 1,
    'bz' => 1,
    'bj' => 1,
    'bm' => 1,
    'bt' => 1,
    'bo' => 1,
    'ba' => 1,
    'bw' => 1,
    'bv' => 1,
    'br' => 1,
    'io' => 1,
    'bn' => 1,
    'bg' => 1,
    'bf' => 1,
    'bi' => 1,
    'kh' => 1,
    'cm' => 1,
    'ca' => 1,
    'cv' => 1,
    'ky' => 1,
    'cf' => 1,
    'td' => 1,
    'cl' => 1,
    'cn' => 1,
    'cx' => 1,
    'cc' => 1,
    'co' => 1,
    'km' => 1,
    'cg' => 1,
    'cd' => 1,
    'ck' => 1,
    'cr' => 1,
    'ci' => 1,
    'hr' => 1,
    'cu' => 1,
    'cy' => 1,
    'cz' => 1,
    'dk' => 1,
    'dj' => 1,
    'dm' => 1,
    'do' => 1,
    'ec' => 1,
    'eg' => 1,
    'sv' => 1,
    'gq' => 1,
    'er' => 1,
    'ee' => 1,
    'et' => 1,
    'fk' => 1,
    'fo' => 1,
    'fj' => 1,
    'fi' => 1,
    'fr' => 1,
    'gf' => 1,
    'pf' => 1,
    'tf' => 1,
    'ga' => 1,
    'gm' => 1,
    'ge' => 1,
    'de' => 1,
    'gh' => 1,
    'gi' => 1,
    'gr' => 1,
    'gl' => 1,
    'gd' => 1,
    'gp' => 1,
    'gu' => 1,
    'gt' => 1,
    'gn' => 1,
    'gw' => 1,
    'gy' => 1,
    'ht' => 1,
    'hm' => 1,
    'va' => 1,
    'hn' => 1,
    'hk' => 1,
    'hu' => 1,
    'is' => 1,
    'in' => 1,
    'id' => 1,
    'ir' => 1,
    'iq' => 1,
    'ie' => 1,
    'il' => 1,
    'it' => 1,
    'jm' => 1,
    'jp' => 1,
    'jo' => 1,
    'kz' => 1,
    'ke' => 1,
    'ki' => 1,
    'kp' => 1,
    'kr' => 1,
    'kw' => 1,
    'kg' => 1,
    'la' => 1,
    'lv' => 1,
    'lb' => 1,
    'ls' => 1,
    'lr' => 1,
    'ly' => 1,
    'li' => 1,
    'lt' => 1,
    'lu' => 1,
    'mo' => 1,
    'mk' => 1,
    'mg' => 1,
    'mw' => 1,
    'my' => 1,
    'mv' => 1,
    'ml' => 1,
    'mt' => 1,
    'mh' => 1,
    'mq' => 1,
    'mr' => 1,
    'mu' => 1,
    'yt' => 1,
    'mx' => 1,
    'fm' => 1,
    'md' => 1,
    'mc' => 1,
    'mn' => 1,
    'ms' => 1,
    'ma' => 1,
    'mz' => 1,
    'mm' => 1,
    'na' => 1,
    'nr' => 1,
    'np' => 1,
    'nl' => 1,
    'an' => 1,
    'nc' => 1,
    'nz' => 1,
    'ni' => 1,
    'ne' => 1,
    'ng' => 1,
    'nu' => 1,
    'nf' => 1,
    'mp' => 1,
    'no' => 1,
    'om' => 1,
    'pk' => 1,
    'pw' => 1,
    'ps' => 1,
    'pa' => 1,
    'pg' => 1,
    'py' => 1,
    'pe' => 1,
    'ph' => 1,
    'pn' => 1,
    'pl' => 1,
    'pt' => 1,
    'pr' => 1,
    'qa' => 1,
    're' => 1,
    'ro' => 1,
    'ru' => 1,
    'rw' => 1,
    'sh' => 1,
    'kn' => 1,
    'lc' => 1,
    'pm' => 1,
    'vc' => 1,
    'ws' => 1,
    'sm' => 1,
    'st' => 1,
    'sa' => 1,
    'sn' => 1,
    'cs' => 1,
    'sc' => 1,
    'sl' => 1,
    'sg' => 1,
    'sk' => 1,
    'si' => 1,
    'sb' => 1,
    'so' => 1,
    'za' => 1,
    'gs' => 1,
    'es' => 1,
    'lk' => 1,
    'sd' => 1,
    'sr' => 1,
    'sj' => 1,
    'sz' => 1,
    'se' => 1,
    'ch' => 1,
    'sy' => 1,
    'tw' => 1,
    'tj' => 1,
    'tz' => 1,
    'th' => 1,
    'tl' => 1,
    'tg' => 1,
    'tk' => 1,
    'to' => 1,
    'tt' => 1,
    'tn' => 1,
    'tr' => 1,
    'tm' => 1,
    'tc' => 1,
    'tv' => 1,
    'ug' => 1,
    'ua' => 1,
    'ae' => 1,
    'uk' => 1,
    'us' => 1,
    'um' => 1,
    'uy' => 1,
    'uz' => 1,
    'vu' => 1,
    've' => 1,
    'vn' => 1,
    'vg' => 1,
    'vi' => 1,
    'wf' => 1,
    'eh' => 1,
    'ye' => 1,
    'zm' => 1,
    'zw' => 1
};

Readonly my $INTERFACE_LANGUAGE =>
{
    'af'    => 1,
    'sq'    => 1,
    'sm'    => 1,
    'ar'    => 1,
    'az'    => 1,
    'eu'    => 1,
    'be'    => 1,
    'bn'    => 1,
    'bh'    => 1,
    'bs'    => 1,
    'bg'    => 1,
    'ca'    => 1,
    'zh-cn' => 1,
    'zh-tw' => 1,
    'hr'    => 1,
    'cs'    => 1,
    'da'    => 1,
    'nl'    => 1,
    'en'    => 1,
    'eo'    => 1,
    'et'    => 1,
    'fo'    => 1,
    'fi'    => 1,
    'fr'    => 1,
    'fy'    => 1,
    'gl'    => 1,
    'ka'    => 1,
    'de'    => 1,
    'el'    => 1,
    'gu'    => 1,
    'iw'    => 1,
    'hi'    => 1,
    'hu'    => 1,
    'is'    => 1,
    'id'    => 1,
    'ia'    => 1,
    'ga'    => 1,
    'it'    => 1,
    'ja'    => 1,
    'jw'    => 1,
    'kn'    => 1,
    'ko'    => 1,
    'la'    => 1,
    'lv'    => 1,
    'lt'    => 1,
    'mk'    => 1,
    'ms'    => 1,
    'ml'    => 1,
    'mt'    => 1,
    'mr'    => 1,
    'ne'    => 1,
    'no'    => 1,
    'nn'    => 1,
    'oc'    => 1,
    'fa'    => 1,
    'pl'    => 1,
    'pt-br' => 1,
    'pt-pt' => 1,
    'pa'    => 1,
    'ro'    => 1,
    'ru'    => 1,
    'gd'    => 1,
    'sr'    => 1,
    'si'    => 1,
    'sk'    => 1,
    'sl'    => 1,
    'es'    => 1,
    'su'    => 1,
    'sw'    => 1,
    'sv'    => 1,
    'tl'    => 1,
    'ta'    => 1,
    'te'    => 1,
    'th'    => 1,
    'ti'    => 1,
    'tr'    => 1,
    'uk'    => 1,
    'ur'    => 1,
    'uz'    => 1,
    'vi'    => 1,
    'cy'    => 1,
    'xh'    => 1,
    'zu'    => 1
};

Readonly my $FILE_TYPE =>
{
    '.swf'  => 1,
    '.pdf'  => 1,
    '.ps'   => 1,
    '.dwf'  => 1,
    '.kml'  => 1,
    '.kmz'  => 1,
    '.gpx'  => 1,
    '.hwp'  => 1,
    '.htm'  => 1,
    '.html' => 1,
    '.xls'  => 1,
    '.xlsx' => 1,
    '.ppt'  => 1,
    '.pptx' => 1,
    '.doc'  => 1,
    '.docx' => 1,
    '.odp'  => 1,
    '.ods'  => 1,
    '.odt'  => 1,
    '.rtf'  => 1,
    '.wri'  => 1,
    '.svg'  => 1,
    '.tex'  => 1,
    '.txt'  => 1,
    '.text' => 1,
    '.bas'  => 1,
    '.c'    => 1,
    '.cc'   => 1,
    '.cpp'  => 1,
    '.cxx'  => 1,
    '.h'    => 1,
    '.hpp'  => 1,
    '.cs'   => 1,
    '.java' => 1,
    '.pl'   => 1,
    '.py'   => 1,
    '.wml'  => 1,
    '.wap'  => 1,
    '.xml'  => 1
};

Readonly my $COLOR_TYPE =>
{
    'color' => 1,
    'gray'  => 1,
    'mono'  => 1
};

Readonly my $DOMINANT_COLOR =>
{
    'black'  => 1,
    'blue'   => 1,
    'brown'  => 1,
    'gray'   => 1,
    'green'  => 1,
    'pink'   => 1,
    'purple' => 1,
    'teal'   => 1,
    'white'  => 1,
    'yellow' => 1
};

Readonly my $IMAGE_SIZE =>
{
    'huge'   => 1,
    'icon'   => 1,
    'large'  => 1,
    'medium' => 1,
    'small'  => 1,
    'xlarge' => 1,
    'xxlarge'=> 1
};

Readonly my $IMAGE_TYPE =>
{
    'clipart' => 1,
    'face'    => 1,
    'lineart' => 1,
    'news'    => 1,
    'photo'   => 1
};

Readonly my $RIGHTS =>
{
    'cc_publicdomain'  => 1,
    'cc_attribute'     => 1,
    'cc_sharealike'    => 1,
    'cc_noncommercial' => 1,
    'cc_nonderived'    => 1
};

Readonly my $SEARCH_TYPE =>
{
    'image' => 1
};

Readonly my $SEARCH_FILTER =>
{
    'e' => 1,
    'i' => 1
};

=head1 NAME

WWW::Google::CustomSearch - Interface to Google JSON/Atom Custom Search.

=head1 VERSION

Version 0.11

=cut

our $VERSION = '0.11';

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

For more information about the Google JSON/Atom Custom Search API, please visit
L<https://developers.google.com/custom-search/json-api/v1/reference/cse/list>

Important:The version v1 of the Google JSON/Atom Custom Search API is in Labs and its features
might change unexpectedly until it graduates.

=head1 SYNOPSIS

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';
    my $engine  = WWW::Google::CustomSearch->new(api_key=>$api_key, cx=>$cx);

    # Perform search (croaks on failure)
    my $result = $engine->search('Google');

    # Time to perform search
    print "Search time: ", $result->searchTime, "\n";

    # Show search result snippet
    foreach $item ($result->items) {
        print "Snippet: ", $item->snippet, "\n";
    }

See L<WWW::Google::CustomSearch::Result> for further details of the search result.

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

=head1 Country Collection Values (cr)

    +----------------------------------------------+---------------------------+
    | Country                                      | Country Collection Name   |
    +----------------------------------------------+---------------------------+
    | Afghanistan                                  | countryAF                 |
    | Albania                                      | countryAL                 |
    | Algeria                                      | countryDZ                 |
    | American Samoa                               | countryAS                 |
    | Andorra                                      | countryAD                 |
    | Angola                                       | countryAO                 |
    | Anguilla                                     | countryAI                 |
    | Antarctica                                   | countryAQ                 |
    | Antigua and Barbuda                          | countryAG                 |
    | Argentina                                    | countryAR                 |
    | Armenia                                      | countryAM                 |
    | Aruba                                        | countryAW                 |
    | Australia                                    | countryAU                 |
    | Austria                                      | countryAT                 |
    | Azerbaijan                                   | countryAZ                 |
    | Bahamas                                      | countryBS                 |
    | Bahrain                                      | countryBH                 |
    | Bangladesh                                   | countryBD                 |
    | Barbados                                     | countryBB                 |
    | Belarus                                      | countryBY                 |
    | Belgium                                      | countryBE                 |
    | Belize                                       | countryBZ                 |
    | Benin                                        | countryBJ                 |
    | Bermuda                                      | countryBM                 |
    | Bhutan                                       | countryBT                 |
    | Bolivia                                      | countryBO                 |
    | Bosnia and Herzegovina                       | countryBA                 |
    | Botswana                                     | countryBW                 |
    | Bouvet Island                                | countryBV                 |
    | Brazil                                       | countryBR                 |
    | British Indian Ocean Territory               | countryIO                 |
    | Brunei Darussalam                            | countryBN                 |
    | Bulgaria                                     | countryBG                 |
    | Burkina Faso                                 | countryBF                 |
    | Burundi                                      | countryBI                 |
    | Cambodia                                     | countryKH                 |
    | Cameroon                                     | countryCM                 |
    | Canada                                       | countryCA                 |
    | Cape Verde                                   | countryCV                 |
    | Cayman Islands                               | countryKY                 |
    | Central African Republic                     | countryCF                 |
    | Chad                                         | countryTD                 |
    | Chile                                        | countryCL                 |
    | China                                        | countryCN                 |
    | Christmas Island                             | countryCX                 |
    | Cocos (Keeling) Islands                      | countryCC                 |
    | Colombia                                     | countryCO                 |
    | Comoros                                      | countryKM                 |
    | Congo                                        | countryCG                 |
    | Congo, the Democratic Republic of the        | countryCD                 |
    | Cook Islands                                 | countryCK                 |
    | Costa Rica                                   | countryCR                 |
    | Cote D'ivoire                                | countryCI                 |
    | Croatia (Hrvatska)                           | countryHR                 |
    | Cuba                                         | countryCU                 |
    | Cyprus                                       | countryCY                 |
    | Czech Republic                               | countryCZ                 |
    | Denmark                                      | countryDK                 |
    | Djibouti                                     | countryDJ                 |
    | Dominica                                     | countryDM                 |
    | Dominican Republic                           | countryDO                 |
    | East Timor                                   | countryTP                 |
    | Ecuador                                      | countryEC                 |
    | Egypt                                        | countryEG                 |
    | El Salvador                                  | countrySV                 |
    | Equatorial Guinea                            | countryGQ                 |
    | Eritrea                                      | countryER                 |
    | Estonia                                      | countryEE                 |
    | Ethiopia                                     | countryET                 |
    | European Union                               | countryEU                 |
    | Falkland Islands (Malvinas)                  | countryFK                 |
    | Faroe Islands                                | countryFO                 |
    | Fiji                                         | countryFJ                 |
    | Finland                                      | countryFI                 |
    | France                                       | countryFR                 |
    | France, Metropolitan                         | countryFX                 |
    | French Guiana                                | countryGF                 |
    | French Polynesia                             | countryPF                 |
    | French Southern Territories                  | countryTF                 |
    | Gabon                                        | countryGA                 |
    | Gambia                                       | countryGM                 |
    | Georgia                                      | countryGE                 |
    | Germany                                      | countryDE                 |
    | Ghana                                        | countryGH                 |
    | Gibraltar                                    | countryGI                 |
    | Greece                                       | countryGR                 |
    | Greenland                                    | countryGL                 |
    | Grenada                                      | countryGD                 |
    | Guadeloupe                                   | countryGP                 |
    | Guam                                         | countryGU                 |
    | Guatemala                                    | countryGT                 |
    | Guinea                                       | countryGN                 |
    | Guinea-Bissau                                | countryGW                 |
    | Guyana                                       | countryGY                 |
    | Haiti                                        | countryHT                 |
    | Heard Island and Mcdonald Islands            | countryHM                 |
    | Holy See (Vatican City State)                | countryVA                 |
    | Honduras                                     | countryHN                 |
    | Hong Kong                                    | countryHK                 |
    | Hungary                                      | countryHU                 |
    | Iceland                                      | countryIS                 |
    | India                                        | countryIN                 |
    | Indonesia                                    | countryID                 |
    | Iran, Islamic Republic of                    | countryIR                 |
    | Iraq                                         | countryIQ                 |
    | Ireland                                      | countryIE                 |
    | Israel                                       | countryIL                 |
    | Italy                                        | countryIT                 |
    | Jamaica                                      | countryJM                 |
    | Japan                                        | countryJP                 |
    | Jordan                                       | countryJO                 |
    | Kazakhstan                                   | countryKZ                 |
    | Kenya                                        | countryKE                 |
    | Kiribati                                     | countryKI                 |
    | Korea, Democratic People's Republic of       | countryKP                 |
    | Korea, Republic of                           | countryKR                 |
    | Kuwait                                       | countryKW                 |
    | Kyrgyzstan                                   | countryKG                 |
    | Lao People's Democratic Republic             | countryLA                 |
    | Latvia                                       | countryLV                 |
    | Lebanon                                      | countryLB                 |
    | Lesotho                                      | countryLS                 |
    | Liberia                                      | countryLR                 |
    | Libyan Arab Jamahiriya                       | countryLY                 |
    | Liechtenstein                                | countryLI                 |
    | Lithuania                                    | countryLT                 |
    | Luxembourg                                   | countryLU                 |
    | Macao                                        | countryMO                 |
    | Macedonia, the Former Yugosalv Republic of   | countryMK                 |
    | Madagascar                                   | countryMG                 |
    | Malawi                                       | countryMW                 |
    | Malaysia                                     | countryMY                 |
    | Maldives                                     | countryMV                 |
    | Mali                                         | countryML                 |
    | Malta                                        | countryMT                 |
    | Marshall Islands                             | countryMH                 |
    | Martinique                                   | countryMQ                 |
    | Mauritania                                   | countryMR                 |
    | Mauritius                                    | countryMU                 |
    | Mayotte                                      | countryYT                 |
    | Mexico                                       | countryMX                 |
    | Micronesia, Federated States of              | countryFM                 |
    | Moldova, Republic of                         | countryMD                 |
    | Monaco                                       | countryMC                 |
    | Mongolia                                     | countryMN                 |
    | Montserrat                                   | countryMS                 |
    | Morocco                                      | countryMA                 |
    | Mozambique                                   | countryMZ                 |
    | Myanmar                                      | countryMM                 |
    | Namibia                                      | countryNA                 |
    | Nauru                                        | countryNR                 |
    | Nepal                                        | countryNP                 |
    | Netherlands                                  | countryNL                 |
    | Netherlands Antilles                         | countryAN                 |
    | New Caledonia                                | countryNC                 |
    | New Zealand                                  | countryNZ                 |
    | Nicaragua                                    | countryNI                 |
    | Niger                                        | countryNE                 |
    | Nigeria                                      | countryNG                 |
    | Niue                                         | countryNU                 |
    | Norfolk Island                               | countryNF                 |
    | Northern Mariana Islands                     | countryMP                 |
    | Norway                                       | countryNO                 |
    | Oman                                         | countryOM                 |
    | Pakistan                                     | countryPK                 |
    | Palau                                        | countryPW                 |
    | Palestinian Territory                        | countryPS                 |
    | Panama                                       | countryPA                 |
    | Papua New Guinea                             | countryPG                 |
    | Paraguay                                     | countryPY                 |
    | Peru                                         | countryPE                 |
    | Philippines                                  | countryPH                 |
    | Pitcairn                                     | countryPN                 |
    | Poland                                       | countryPL                 |
    | Portugal                                     | countryPT                 |
    | Puerto Rico                                  | countryPR                 |
    | Qatar                                        | countryQA                 |
    | Reunion                                      | countryRE                 |
    | Romania                                      | countryRO                 |
    | Russian Federation                           | countryRU                 |
    | Rwanda                                       | countryRW                 |
    | Saint Helena                                 | countrySH                 |
    | Saint Kitts and Nevis                        | countryKN                 |
    | Saint Lucia                                  | countryLC                 |
    | Saint Pierre and Miquelon                    | countryPM                 |
    | Saint Vincent and the Grenadines             | countryVC                 |
    | Samoa                                        | countryWS                 |
    | San Marino                                   | countrySM                 |
    | Sao Tome and Principe                        | countryST                 |
    | Saudi Arabia                                 | countrySA                 |
    | Senegal                                      | countrySN                 |
    | Serbia and Montenegro                        | countryCS                 |
    | Seychelles                                   | countrySC                 |
    | Sierra Leone                                 | countrySL                 |
    | Singapore                                    | countrySG                 |
    | Slovakia                                     | countrySK                 |
    | Slovenia                                     | countrySI                 |
    | Solomon Islands                              | countrySB                 |
    | Somalia                                      | countrySO                 |
    | South Africa                                 | countryZA                 |
    | South Georgia and the South Sandwich Islands | countryGS                 |
    | Spain                                        | countryES                 |
    | Sri Lanka                                    | countryLK                 |
    | Sudan                                        | countrySD                 |
    | Suriname                                     | countrySR                 |
    | Svalbard and Jan Mayen                       | countrySJ                 |
    | Swaziland                                    | countrySZ                 |
    | Sweden                                       | countrySE                 |
    | Switzerland                                  | countryCH                 |
    | Syrian Arab Republic                         | countrySY                 |
    | Taiwan, Province of China                    | countryTW                 |
    | Tajikistan                                   | countryTJ                 |
    | Tanzania, United Republic of                 | countryTZ                 |
    | Thailand                                     | countryTH                 |
    | Togo                                         | countryTG                 |
    | Tokelau                                      | countryTK                 |
    | Tonga                                        | countryTO                 |
    | Trinidad and Tobago                          | countryTT                 |
    | Tunisia                                      | countryTN                 |
    | Turkey                                       | countryTR                 |
    | Turkmenistan                                 | countryTM                 |
    | Turks and Caicos Islands                     | countryTC                 |
    | Tuvalu                                       | countryTV                 |
    | Uganda                                       | countryUG                 |
    | Ukraine                                      | countryUA                 |
    | United Arab Emirates                         | countryAE                 |
    | United Kingdom                               | countryUK                 |
    | United States                                | countryUS                 |
    | United States Minor Outlying Islands         | countryUM                 |
    | Uruguay                                      | countryUY                 |
    | Uzbekistan                                   | countryUZ                 |
    | Vanuatu                                      | countryVU                 |
    | Venezuela                                    | countryVE                 |
    | Vietnam                                      | countryVN                 |
    | Virgin Islands, British                      | countryVG                 |
    | Virgin Islands, U.S.                         | countryVI                 |
    | Wallis and Futuna                            | countryWF                 |
    | Western Sahara                               | countryEH                 |
    | Yemen                                        | countryYE                 |
    | Yugoslavia                                   | countryYU                 |
    | Zambia                                       | countryZM                 |
    | Zimbabwe                                     | countryZW                 |
    +----------------------------------------------+---------------------------+

=head1 Country Codes (gl)

    +----------------------------------------------+---------------+
    | Country                                      | Country Code  |
    +----------------------------------------------+---------------+
    | Afghanistan                                  | af            |
    | Albania                                      | al            |
    | Algeria                                      | dz            |
    | American Samoa                               | as            |
    | Andorra                                      | ad            |
    | Angola                                       | ao            |
    | Anguilla                                     | ai            |
    | Antarctica                                   | aq            |
    | Antigua and Barbuda                          | ag            |
    | Argentina                                    | ar            |
    | Armenia                                      | am            |
    | Aruba                                        | aw            |
    | Australia                                    | au            |
    | Austria                                      | at            |
    | Azerbaijan                                   | az            |
    | Bahamas                                      | bs            |
    | Bahrain                                      | bh            |
    | Bangladesh                                   | bd            |
    | Barbados                                     | bb            |
    | Belarus                                      | by            |
    | Belgium                                      | be            |
    | Belize                                       | bz            |
    | Benin                                        | bj            |
    | Bermuda                                      | bm            |
    | Bhutan                                       | bt            |
    | Bolivia                                      | bo            |
    | Bosnia and Herzegovina                       | ba            |
    | Botswana                                     | bw            |
    | Bouvet Island                                | bv            |
    | Brazil                                       | br            |
    | British Indian Ocean Territory               | io            |
    | Brunei Darussalam                            | bn            |
    | Bulgaria                                     | bg            |
    | Burkina Faso                                 | bf            |
    | Burundi                                      | bi            |
    | Cambodia                                     | kh            |
    | Cameroon                                     | cm            |
    | Canada                                       | ca            |
    | Cape Verde                                   | cv            |
    | Cayman Islands                               | ky            |
    | Central African Republic                     | cf            |
    | Chad                                         | td            |
    | Chile                                        | cl            |
    | China                                        | cn            |
    | Christmas Island                             | cx            |
    | Cocos (Keeling) Islands                      | cc            |
    | Colombia                                     | co            |
    | Comoros                                      | km            |
    | Congo                                        | cg            |
    | Congo, the Democratic Republic of the        | cd            |
    | Cook Islands                                 | ck            |
    | Costa Rica                                   | cr            |
    | Cote D'ivoire                                | ci            |
    | Croatia                                      | hr            |
    | Cuba                                         | cu            |
    | Cyprus                                       | cy            |
    | Czech Republic                               | cz            |
    | Denmark                                      | dk            |
    | Djibouti                                     | dj            |
    | Dominica                                     | dm            |
    | Dominican Republic                           | do            |
    | Ecuador                                      | ec            |
    | Egypt                                        | eg            |
    | El Salvador                                  | sv            |
    | Equatorial Guinea                            | gq            |
    | Eritrea                                      | er            |
    | Estonia                                      | ee            |
    | Ethiopia                                     | et            |
    | Falkland Islands (Malvinas)                  | fk            |
    | Faroe Islands                                | fo            |
    | Fiji                                         | fj            |
    | Finland                                      | fi            |
    | France                                       | fr            |
    | French Guiana                                | gf            |
    | French Polynesia                             | pf            |
    | French Southern Territories                  | tf            |
    | Gabon                                        | ga            |
    | Gambia                                       | gm            |
    | Georgia                                      | ge            |
    | Germany                                      | de            |
    | Ghana                                        | gh            |
    | Gibraltar                                    | gi            |
    | Greece                                       | gr            |
    | Greenland                                    | gl            |
    | Grenada                                      | gd            |
    | Guadeloupe                                   | gp            |
    | Guam                                         | gu            |
    | Guatemala                                    | gt            |
    | Guinea                                       | gn            |
    | Guinea-Bissau                                | gw            |
    | Guyana                                       | gy            |
    | Haiti                                        | ht            |
    | Heard Island and Mcdonald Islands            | hm            |
    | Holy See (Vatican City State)                | va            |
    | Honduras                                     | hn            |
    | Hong Kong                                    | hk            |
    | Hungary                                      | hu            |
    | Iceland                                      | is            |
    | India                                        | in            |
    | Indonesia                                    | id            |
    | Iran, Islamic Republic of                    | ir            |
    | Iraq                                         | iq            |
    | Ireland                                      | ie            |
    | Israel                                       | il            |
    | Italy                                        | it            |
    | Jamaica                                      | jm            |
    | Japan                                        | jp            |
    | Jordan                                       | jo            |
    | Kazakhstan                                   | kz            |
    | Kenya                                        | ke            |
    | Kiribati                                     | ki            |
    | Korea, Democratic People's Republic of       | kp            |
    | Korea, Republic of                           | kr            |
    | Kuwait                                       | kw            |
    | Kyrgyzstan                                   | kg            |
    | Lao People's Democratic Republic             | la            |
    | Latvia                                       | lv            |
    | Lebanon                                      | lb            |
    | Lesotho                                      | ls            |
    | Liberia                                      | lr            |
    | Libyan Arab Jamahiriya                       | ly            |
    | Liechtenstein                                | li            |
    | Lithuania                                    | lt            |
    | Luxembourg                                   | lu            |
    | Macao                                        | mo            |
    | Macedonia, the Former Yugosalv Republic of   | mk            |
    | Madagascar                                   | mg            |
    | Malawi                                       | mw            |
    | Malaysia                                     | my            |
    | Maldives                                     | mv            |
    | Mali                                         | ml            |
    | Malta                                        | mt            |
    | Marshall Islands                             | mh            |
    | Martinique                                   | mq            |
    | Mauritania                                   | mr            |
    | Mauritius                                    | mu            |
    | Mayotte                                      | yt            |
    | Mexico                                       | mx            |
    | Micronesia, Federated States of              | fm            |
    | Moldova, Republic of                         | md            |
    | Monaco                                       | mc            |
    | Mongolia                                     | mn            |
    | Montserrat                                   | ms            |
    | Morocco                                      | ma            |
    | Mozambique                                   | mz            |
    | Myanmar                                      | mm            |
    | Namibia                                      | na            |
    | Nauru                                        | nr            |
    | Nepal                                        | np            |
    | Netherlands                                  | nl            |
    | Netherlands Antilles                         | an            |
    | New Caledonia                                | nc            |
    | New Zealand                                  | nz            |
    | Nicaragua                                    | ni            |
    | Niger                                        | ne            |
    | Nigeria                                      | ng            |
    | Niue                                         | nu            |
    | Norfolk Island                               | nf            |
    | Northern Mariana Islands                     | mp            |
    | Norway                                       | no            |
    | Oman                                         | om            |
    | Pakistan                                     | pk            |
    | Palau                                        | pw            |
    | Palestinian Territory, Occupied              | ps            |
    | Panama                                       | pa            |
    | Papua New Guinea                             | pg            |
    | Paraguay                                     | py            |
    | Peru                                         | pe            |
    | Philippines                                  | ph            |
    | Pitcairn                                     | pn            |
    | Poland                                       | pl            |
    | Portugal                                     | pt            |
    | Puerto Rico                                  | pr            |
    | Qatar                                        | qa            |
    | Reunion                                      | re            |
    | Romania                                      | ro            |
    | Russian Federation                           | ru            |
    | Rwanda                                       | rw            |
    | Saint Helena                                 | sh            |
    | Saint Kitts and Nevis                        | kn            |
    | Saint Lucia                                  | lc            |
    | Saint Pierre and Miquelon                    | pm            |
    | Saint Vincent and the Grenadines             | vc            |
    | Samoa                                        | ws            |
    | San Marino                                   | sm            |
    | Sao Tome and Principe                        | st            |
    | Saudi Arabia                                 | sa            |
    | Senegal                                      | sn            |
    | Serbia and Montenegro                        | cs            |
    | Seychelles                                   | sc            |
    | Sierra Leone                                 | sl            |
    | Singapore                                    | sg            |
    | Slovakia                                     | sk            |
    | Slovenia                                     | si            |
    | Solomon Islands                              | sb            |
    | Somalia                                      | so            |
    | South Africa                                 | za            |
    | South Georgia and the South Sandwich Islands | gs            |
    | Spain                                        | es            |
    | Sri Lanka                                    | lk            |
    | Sudan                                        | sd            |
    | Suriname                                     | sr            |
    | Svalbard and Jan Mayen                       | sj            |
    | Swaziland                                    | sz            |
    | Sweden                                       | se            |
    | Switzerland                                  | ch            |
    | Syrian Arab Republic                         | sy            |
    | Taiwan, Province of China                    | tw            |
    | Tajikistan                                   | tj            |
    | Tanzania, United Republic of                 | tz            |
    | Thailand                                     | th            |
    | Timor-Leste                                  | tl            |
    | Togo                                         | tg            |
    | Tokelau                                      | tk            |
    | Tonga                                        | to            |
    | Trinidad and Tobago                          | tt            |
    | Tunisia                                      | tn            |
    | Turkey                                       | tr            |
    | Turkmenistan                                 | tm            |
    | Turks and Caicos Islands                     | tc            |
    | Tuvalu                                       | tv            |
    | Uganda                                       | ug            |
    | Ukraine                                      | ua            |
    | United Arab Emirates                         | ae            |
    | United Kingdom                               | uk            |
    | United States                                | us            |
    | United States Minor Outlying Islands         | um            |
    | Uruguay                                      | uy            |
    | Uzbekistan                                   | uz            |
    | Vanuatu                                      | vu            |
    | Venezuela                                    | ve            |
    | Viet Nam                                     | vn            |
    | Virgin Islands, British                      | vg            |
    | Virgin Islands, U.S.                         | vi            |
    | Wallis and Futuna                            | wf            |
    | Western Sahara                               | eh            |
    | Yemen                                        | ye            |
    | Zambia                                       | zm            |
    | Zimbabwe                                     | zw            |
    +----------------------------------------------+---------------+

=head1 Interface Language (hl)

    +---------------------------+-----------------+
    | Display Language          | Parameter Value |
    +---------------------------+-----------------+
    | Afrikaans                 | af              |
    | Albanian                  | sq              |
    | Amharic                   | sm              |
    | Arabic                    | ar              |
    | Azerbaijani               | az              |
    | Basque                    | eu              |
    | Belarusian                | be              |
    | Bengali                   | bn              |
    | Bihari                    | bh              |
    | Bosnian                   | bs              |
    | Bulgarian                 | bg              |
    | Catalan                   | ca              |
    | Chinese (Simplified)      | zh-CN           |
    | Chinese (Traditional)     | zh-TW           |
    | Croatian                  | hr              |
    | Czech                     | cs              |
    | Danish                    | da              |
    | Dutch                     | nl              |
    | English                   | en              |
    | Esperanto                 | eo              |
    | Estonian                  | et              |
    | Faroese                   | fo              |
    | Finnish                   | fi              |
    | French                    | fr              |
    | Frisian                   | fy              |
    | Galician                  | gl              |
    | Georgian                  | ka              |
    | German                    | de              |
    | Greek                     | el              |
    | Gujarati                  | gu              |
    | Hebrew                    | iw              |
    | Hindi                     | hi              |
    | Hungarian                 | hu              |
    | Icelandic                 | is              |
    | Indonesian                | id              |
    | Interlingua               | ia              |
    | Irish                     | ga              |
    | Italian                   | it              |
    | Japanese                  | ja              |
    | Javanese                  | jw              |
    | Kannada                   | kn              |
    | Korean                    | ko              |
    | Latin                     | la              |
    | Latvian                   | lv              |
    | Lithuanian                | lt              |
    | Macedonian                | mk              |
    | Malay                     | ms              |
    | Malayam                   | ml              |
    | Maltese                   | mt              |
    | Marathi                   | mr              |
    | Nepali                    | ne              |
    | Norwegian                 | no              |
    | Norwegian (Nynorsk)       | nn              |
    | Occitan                   | oc              |
    | Persian                   | fa              |
    | Polish                    | pl              |
    | Portuguese (Brazil)       | pt-BR           |
    | Portuguese (Portugal)     | pt-PT           |
    | Punjabi                   | pa              |
    | Romanian                  | ro              |
    | Russian                   | ru              |
    | Scots Gaelic              | gd              |
    | Serbian                   | sr              |
    | Sinhalese                 | si              |
    | Slovak                    | sk              |
    | Slovenian                 | sl              |
    | Spanish                   | es              |
    | Sudanese                  | su              |
    | Swahili                   | sw              |
    | Swedish                   | sv              |
    | Tagalog                   | tl              |
    | Tamil                     | ta              |
    | Telugu                    | te              |
    | Thai                      | th              |
    | Tigrinya                  | ti              |
    | Turkish                   | tr              |
    | Ukrainian                 | uk              |
    | Urdu                      | ur              |
    | Uzbek                     | uz              |
    | Vietnamese                | vi              |
    | Welsh                     | cy              |
    | Xhosa                     | xh              |
    | Zulu                      | zu              |
    +---------------------------+-----------------+

=head1 File Types

    +--------------------------------+-------------------------------+
    | File Type                      | Extension                     |
    +--------------------------------+-------------------------------+
    | Adobe Flash                    | .swf                          |
    | Adobe Portable Document Format | .pdf                          |
    | Adobe PostScript               | .ps                           |
    | Autodesk Design Web Format     | .dwf                          |
    | Google Earth                   | .kml, .kmz                    |
    | GPS eXchange Format            | .gpx                          |
    | Hancom Hanword                 | .hwp                          |
    | HTML                           | .htm, .html                   |
    | Microsoft Excel                | .xls, .xlsx                   |
    | Microsoft PowerPoint           | .ppt, .pptx                   |
    | Microsoft Word                 | .doc, .docx                   |
    | OpenOffice presentation        | .odp                          |
    | OpenOffice spreadsheet         | .ods                          |
    | OpenOffice text                | .odt                          |
    | Rich Text Format               | .rtf, .wri                    |
    | Scalable Vector Graphics       | .svg                          |
    | TeX/LaTeX                      | .tex                          |
    | Text                           | .txt, .text                   |
    | Basic source code              | .bas                          |
    | C/C++ source code              | .c, .cc, .cpp, .cxx, .h, .hpp |
    | C# source code                 | .cs                           |
    | Java source code               | .java                         |
    | Perl source code               | .pl                           |
    | Python source code             | .py                           |
    | Wireless Markup Language       | .wml, .wap                    |
    | XML                            | .xml                          |
    +--------------------------------+-------------------------------+

=head1 CONSTRUCTOR

The constructor expects your application API Key & Custom search engine identifier. Use either
C<cx> or C<cref> to specify the custom search engine you want to perform this search.  If both
are specified, C<cx> is used.

    +------------------+----------------------------------------------------------------------------+
    | Key              | Description                                                                |
    +------------------+----------------------------------------------------------------------------+
    | api_key          | Your application API Key.                                                  |
    |                  |                                                                            |
    | callback         | Callback function. Name of the JavaScript callback function that handles   |
    |                  | the response.                                                              |
    |                  |                                                                            |
    | fields           | Selector specifying a subset of fields to include in the response.         |
    |                  |                                                                            |
    | prettyprint      | Returns a response with indentations and line breaks.                      |
    |                  | If prettyprint=true, the results returned by the server will be human      |
    |                  | readable (pretty printed).                                                 |
    |                  |                                                                            |
    | userIp           | IP address of the end user for whom the API call is being made.            |
    |                  |                                                                            |
    | quotaUser        | Alternative to userIp. Lets you enforce per-user quotas from a server-side |
    |                  | application even in cases when the user's IP address is unknown. You can   |
    |                  | choose any arbitrary string that uniquely identifies a user, but it is     |
    |                  | limited to 40 characters. Overrides userIp if both are provided.           |
    |                  |                                                                            |
    | c2coff           | Enables or disables Simplified and Traditional Chinese Search.             |
    |                  | The default value for this parameter is 0 (zero), meaning that             |
    |                  | the feature is enabled. Supported values are:                              |
    |                  | * 1 - Disabled                                                             |
    |                  | * 2 - Enabled (default)                                                    |
    |                  |                                                                            |
    | cr               | Restricts search results to documents originating in a particular          |
    |                  | country. See section "Country Collection Name" for valid data.             |
    |                  |                                                                            |
    | cref             | For a linked custom search engine.                                         |
    |                  |                                                                            |
    | cx               | For a search engine created with the Google Custom Search page.            |
    |                  |                                                                            |
    | dateRestrict     | Restricts results to URLs based on date. Supported values include:         |
    |                  | * d[number]: requests results from the specified number of past days.      |
    |                  | * w[number]: requests results from the specified number of past weeks.     |
    |                  | * m[number]: requests results from the specified number of past months.    |
    |                  | * y[number]: requests results from the specified number of past years.     |
    |                  |                                                                            |
    | exactTerms       | Identifies a phrase that all documents in the search results must          |
    |                  | contain.                                                                   |
    |                  |                                                                            |
    | excludeTerms     | Identifies a word or phrase that should not appear in any documents in     |
    |                  | the search results.                                                        |
    |                  |                                                                            |
    | fileType         | Restricts results to files of a specified extension.                       |
    |                  |                                                                            |
    | filter           | Controls turning on or off the duplicate content filter.                   |
    |                  | * filter=0 - Turns off the duplicate content filter.                       |
    |                  | * filter=1 - Turns on the duplicate content filter (default).              |
    |                  |                                                                            |
    | gl               | Geolocation of end user. The gl parameter value is a two-letter country    |
    |                  | code. See section "Country Codes".                                         |
    |                  |                                                                            |
    | googlehost       | The local Google domain (for example, google.com, google.de, or google.fr) |
    |                  | to use to perform the search. Default "www.google.com".                    |
    |                  |                                                                            |
    | highRange        | Specifies the ending value for a search range.                             |
    |                  |                                                                            |
    | hl               | Sets the user interface language. Explicitly setting this parameter        |
    |                  | improves the performance and the quality of your search results. See       |
    |                  | section "Interface Language"                                               |
    |                  |                                                                            |
    | hq               | Appends the specified query terms to the query, as if they were combined   |
    |                  | with a logical AND operator.                                               |
    |                  |                                                                            |
    | imgColorType     | Returns black and white, grayscale, or color images. Acceptable values     |
    |                  | are mono, gray, and color.                                                 |
    |                  |                                                                            |
    | imgDominantColor | Returns images of a specific dominant color. Acceptable values are "black" |
    |                  | "blue", "brown", "gray", "green", "pink", "purple", "teal", "white",       |
    |                  | "yellow".                                                                  |
    |                  |                                                                            |
    | imgSize          | Returns images of a specified size. Acceptable values are "huge", "icon"   |
    |                  | "large", "medium", "small", "xlarge", "xxlarge".                           |
    |                  |                                                                            |
    | imgType          | Returns images of a type. Acceptable values are "clipart", "face", "news"  |
    |                  | "lineart", "photo".                                                        |
    |                  |                                                                            |
    | linkSite         | Specifies that all search results should contain a link to a particular URL|
    |                  |                                                                            |
    | lowRange         | Specifies the starting value for a search range.                           |
    |                  |                                                                            |
    | lr               | The language restriction for the search results.                           |
    |                  |                                                                            |
    | num              | Number of search results to return. Valid values are integers              |
    |                  | between 1 and 10, Default is 10.                                           |
    |                  |                                                                            |
    | orTerms          | Provides additional search terms to check for in a document, where each    |
    |                  | document in the search results must contain at least one of the additional |
    |                  | search terms.                                                              |
    |                  |                                                                            |
    | relatedSite      | Specifies that all search results should be pages that are related to the  |
    |                  | specified URL.                                                             |
    |                  |                                                                            |
    | rights           | Filters based on licensing. Supported values include:                      |
    |                  | * cc_publicdomain                                                          |
    |                  | * cc_attribute                                                             |
    |                  | * cc_sharealike                                                            |
    |                  | * cc_noncommercial                                                         |
    |                  | * cc_nonderived, and combinations of these.                                |
    |                  |                                                                            |
    | safe             | Search safety level. Default is off. Possible values are:                  |
    |                  | * high - enables highest level of safe search filtering.                   |
    |                  | * medium - enables moderate safe search filtering.                         |
    |                  | * off - disables safe search filtering.                                    |
    |                  |                                                                            |
    | searchType       | Specifies the search type: image.  If unspecified, results are limited to  |
    |                  | webpages.                                                                  |
    |                  |                                                                            |
    | siteSearch       | Specifies all search results should be pages from a given site.            |
    |                  |                                                                            |
    | siteSearchFilter | Controls whether to include or exclude results from the site named in the  |
    |                  | siteSearch parameter. Acceptable values are:                               |
    |                  | * "e": exclude                                                             |
    |                  | * "i": include                                                             |
    |                  |                                                                            |
    | sort             | The sort expression to apply to the results.                               |
    |                  |                                                                            |
    | start            | The index of the first result to return.Valid values are between           |
    |                  | 1 and 91. Default is 1.                                                    |
    +------------------+----------------------------------------------------------------------------+

=cut

type 'Language'          => where { exists($LANGUAGE->{lc($_)})           };
type 'CountryCollection' => where { exists($COUNTRY_COLLECTION->{lc($_)}) };
type 'FileType'          => where { exists($FILE_TYPE->{lc($_)})          };
type 'CountryCode'       => where { exists($COUNTRY_CODE->{lc($_)})       };
type 'InterfaceLanguage' => where { exists($INTERFACE_LANGUAGE->{lc($_)}) };
type 'ColorType'         => where { exists($COLOR_TYPE->{lc($_)})         };
type 'DominantColor'     => where { exists($DOMINANT_COLOR->{lc($_)})     };
type 'ImageSize'         => where { exists($IMAGE_SIZE->{lc($_)})         };
type 'ImageType'         => where { exists($IMAGE_TYPE->{lc($_)})         };
type 'Rights'            => where { exists($RIGHTS->{lc($_)})             };
type 'SearchType'        => where { exists($SEARCH_TYPE->{lc($_)})        };
type 'SearchFilter'      => where { exists($SEARCH_FILTER->{lc($_)})      };
type 'DateRestrict'      => where { (/^[d|w|m|y]\[\d+\]$/i)               };
type 'ZeroOrOne'         => where { (/^[1|0]$/)                           };
type 'StartIndex'        => where { (/^\d{1,2}$/) && ($_>=1) && ($_<=91)  };
type 'ResultCount'       => where { (/^\d{1,2}$/) && ($_>=1) && ($_<=10)  };
type 'OutputFormat'      => where { /\bjson\b|\batom\b/i                  };
type 'TrueFalse'         => where { /\btrue\b|\bfalse\b/i                 };

has  'api_key'          => (is => 'ro', isa => 'Str', required => 1);
has  'callback'         => (is => 'ro', isa => 'Str');
has  'fields'           => (is => 'ro', isa => 'Str');
has  'prettyprint'      => (is => 'ro', isa => 'TrueFalse', default => 'true');
has  'quotaUser'        => (is => 'ro', isa => 'Str');
has  'userIp'           => (is => 'ro', isa => 'Str');
has  'c2coff'           => (is => 'ro', isa => 'ZeroOrOne');
has  'cr'               => (is => 'ro', isa => 'CountryCollection');
has  'cref'             => (is => 'ro', isa => 'Str');
has  'cx'               => (is => 'ro', isa => 'Str');
has  'dateRestrict'     => (is => 'ro', isa => 'DateRestrict');
has  'exactTerms'       => (is => 'ro', isa => 'Str');
has  'excludeTerms'     => (is => 'ro', isa => 'Str');
has  'fileType'         => (is => 'ro', isa => 'FileType');
has  'filter'           => (is => 'ro', isa => 'ZeroOrOne', default => 1);
has  'gl'               => (is => 'ro', isa => 'CountryCode');
has  'googlehost'       => (is => 'ro', isa => 'Str');
has  'highRange'        => (is => 'ro', isa => 'Int');
has  'hl'               => (is => 'ro', isa => 'InterfaceLanguage');
has  'hq'               => (is => 'ro', isa => 'Str');
has  'imgColorType'     => (is => 'ro', isa => 'ColorType');
has  'imgDominantColor' => (is => 'ro', isa => 'DominantColor');
has  'imgSize'          => (is => 'ro', isa => 'ImageSize');
has  'imgType'          => (is => 'ro', isa => 'ImageType');
has  'linkSite'         => (is => 'ro', isa => 'Str');
has  'lowRange'         => (is => 'ro', isa => 'Int');
has  'lr'               => (is => 'ro', isa => 'Language');
has  'num'              => (is => 'ro', isa => 'ResultCount',  default => 10);
has  'orTerms'          => (is => 'ro', isa => 'Str');
has  'relatedSite'      => (is => 'ro', isa => 'Str');
has  'rights'           => (is => 'ro', isa => 'Rights');
has  'safe'             => (is => 'ro', isa => 'SafetyLevel',  default => 'off');
has  'searchType'       => (is => 'ro', isa => 'SearchType');
has  'siteSearch'       => (is => 'ro', isa => 'Str');
has  'siteSearchFilter' => (is => 'ro', isa => 'SearchFilter');
has  'sort'             => (is => 'ro', isa => 'Str');
has  'start'            => (is => 'ro', isa => 'StartIndex',     default => 1);
has  'alt'              => (is => 'ro', isa => 'OutputFormat',   default => 'json');
has  'browser'          => (is => 'rw', isa => 'LWP::UserAgent', default => sub { return LWP::UserAgent->new(); });

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

Get search result L<WWW::Google::CustomSearch::Result> for the given query,  which can be used
to probe for further information about the search result.

    use strict; use warnings;
    use WWW::Google::CustomSearch;

    my $api_key = 'Your_API_Key';
    my $cx      = 'Search_Engine_Identifier';

    # Most recommended format to use key, value as mentioned below which gives
    # flexibility to play with query parameters.
    my $engine1 = WWW::Google::CustomSearch->new(api_key=>$api_key, cx=>$cx, start=>2);
    my $result1 = $engine1->search('Google');

    # NOTE: If you intend to use default settings  for  search engine created with the
    # Google Custom Search then use this format.
    my $engine2 = WWW::Google::CustomSearch->new($api_key, $cx);
    my $result2 = $engine2->search('Google');

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
    $url .= sprintf("&q=%s",                $query);
    $url .= sprintf("&prettyprint=%s",      $self->prettyprint)      if $self->prettyprint;
    $url .= sprintf("&alt=%s",              $self->alt)              if $self->alt;
    $url .= sprintf("&callback=%s",         $self->callback)         if $self->callback;
    $url .= sprintf("&c2coff=%d",           $self->c2coff)           if defined $self->c2coff;
    $url .= sprintf("&cr=%s",               $self->cr)               if $self->cr;
    $url .= sprintf("&dateRestrict=%s",     $self->dateRestrict)     if $self->dateRestrict;
    $url .= sprintf("&exactTerms=%s",       $self->exactTerms)       if $self->exactTerms;
    $url .= sprintf("&excludeTerms=%s",     $self->excludeTerms)     if $self->excludeTerms;
    $url .= sprintf("&fileType=%s",         $self->fileType)         if $self->fileType;
    # RT:72417 by WILLERT.
    $url .= sprintf("&filter=%d",           $self->filter)           if defined $self->filter;
    $url .= sprintf("&gl=%s",               $self->gl)               if $self->gl;
    $url .= sprintf("&googlehost=%s",       $self->googlehost)       if $self->googlehost;
    $url .= sprintf("&highRange=%d",        $self->highRange)        if defined $self->highRange;
    $url .= sprintf("&hl=%s",               $self->hl)               if $self->hl;
    $url .= sprintf("&hq=%s",               $self->hq)               if $self->hq;
    $url .= sprintf("&imgColorType=%s",     $self->imgColorType)     if $self->imgColorType;
    $url .= sprintf("&imgDominantColor=%s", $self->imgDominantColor) if $self->imgDominantColor;
    $url .= sprintf("&imgSize=%s",          $self->imgSize)          if $self->imgSize;
    $url .= sprintf("&imgType=%s",          $self->imgType)          if $self->imgType;
    $url .= sprintf("&linkSite=%s",         $self->linkSite)         if $self->linkSite;
    $url .= sprintf("&lowRange=%d",         $self->lowRange)         if defined $self->lowRange;
    $url .= sprintf("&lr=%s",               $self->lr)               if $self->lr;
    $url .= sprintf("&num=%d",              $self->num)              if $self->num;
    $url .= sprintf("&orTerms=%s",          $self->orTerms)          if $self->orTerms;
    $url .= sprintf("&relatedSite=%s",      $self->relatedSite)      if $self->relatedSite;
    $url .= sprintf("&rights=%s",           $self->rights)           if $self->rights;
    $url .= sprintf("&safe=%s",             $self->safe)             if $self->safe;
    $url .= sprintf("&searchType=%s",       $self->searchType)       if $self->searchType;
    $url .= sprintf("&siteSearch=%s",       $self->siteSearch)       if $self->siteSearch;
    $url .= sprintf("&siteSearchFilter=%s", $self->siteSearchFilter) if $self->siteSearchFilter;
    $url .= sprintf("&sort=%s",             $self->sort)             if $self->sort;
    $url .= sprintf("&start=%d",            $self->start)            if $self->start;

    $request  = HTTP::Request->new(GET => $url);
    $response = $browser->request($request);
    croak("ERROR: Couldn't fetch data [$url]:[".$response->status_line."]\n")
        unless $response->is_success;
    $content  = $response->content;
    croak("ERROR: No data found.\n") unless defined $content;

    if (defined $self->alt && ($self->alt =~ /atom/i)) {
        $content = XMLin($content);
    } else {
        $content = from_json($content);
    }
    return WWW::Google::CustomSearch::Result->new(raw => $content, api_key => $self->api_key);
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
no Moose::Util::TypeConstraints;

1; # End of WWW::Google::CustomSearch