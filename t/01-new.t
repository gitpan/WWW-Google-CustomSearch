#!perl

use strict; use warnings;
use WWW::Google::CustomSearch;
use Test::More tests => 11;

my $api_key = 'Your_API_Key';

eval { WWW::Google::CustomSearch->new($api_key); };
like($@, qr/ERROR: cx or cref must be specified./);

eval { WWW::Google::CustomSearch->new({api_key=>$api_key}); };
like($@, qr/ERROR: cx or cref must be specified./);

eval { WWW::Google::CustomSearch->new({api_key=>$api_key, prettyprint=>'truue'}); };
like($@, qr/Attribute \(prettyprint\) does not pass the type constraint/);

eval { WWW::Google::CustomSearch->new({api_key=>$api_key, alt=>'jsoon'}); };
like($@, qr/Attribute \(alt\) does not pass the type constraint/);

eval { WWW::Google::CustomSearch->new({api_key=>$api_key, lr=>'en'}); };
like($@, qr/Attribute \(lr\) does not pass the type constraint/);

eval { WWW::Google::CustomSearch->new({api_key=>$api_key, num=>12}); };
like($@, qr/Attribute \(num\) does not pass the type constraint/);

eval { WWW::Google::CustomSearch->new({api_key=>$api_key, start=>92}); };
like($@, qr/Attribute \(start\) does not pass the type constraint/);

eval { WWW::Google::CustomSearch->new({api_key=>$api_key, num=>0}); };
like($@, qr/Attribute \(num\) does not pass the type constraint/);

eval { WWW::Google::CustomSearch->new({api_key=>$api_key, start=>0}); };
like($@, qr/Attribute \(start\) does not pass the type constraint/);

eval { WWW::Google::CustomSearch->new({api_key=>$api_key, safe=>'on'}); };
like($@, qr/Attribute \(safe\) does not pass the type constraint/);

eval { WWW::Google::CustomSearch->new({api_key=>$api_key, filter=>-1}); };
like($@, qr/Attribute \(filter\) does not pass the type constraint/);