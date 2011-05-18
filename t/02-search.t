#!perl

use strict; use warnings;
use WWW::Google::CustomSearch;
use Test::More tests => 1;

my ($api_key, $cx, $engine);
$api_key = 'Your_API_Key';
$cx      = 'Search_Engine_Identifier';
$engine  = WWW::Google::CustomSearch->new($api_key, $cx);

eval { $engine->search(); };
like($@, qr/0 parameters were passed to WWW::Google::CustomSearch::search but 1 was expected/);