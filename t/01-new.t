#!perl

use strict; use warnings;
use WWW::Google::CustomSearch;
use Test::More tests => 27;

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

eval { WWW::Google::CustomSearch->new({api_key=>$api_key, c2coff=>-1}); };
like($@, qr/Attribute \(c2coff\) does not pass the type constraint/);

eval { WWW::Google::CustomSearch->new({api_key=>$api_key, cr=>'countryXYZ'}); };
like($@, qr/Attribute \(cr\) does not pass the type constraint/);

eval { WWW::Google::CustomSearch->new({api_key=>$api_key, dateRestrict=>'x1'}); };
like($@, qr/Attribute \(dateRestrict\) does not pass the type constraint/);

eval { WWW::Google::CustomSearch->new({api_key=>$api_key, fileType=>'.xxx'}); };
like($@, qr/Attribute \(fileType\) does not pass the type constraint/);

eval { WWW::Google::CustomSearch->new({api_key=>$api_key, gl=>'xy'}); };
like($@, qr/Attribute \(gl\) does not pass the type constraint/);

eval { WWW::Google::CustomSearch->new({api_key=>$api_key, highRange=>'x'}); };
like($@, qr/Attribute \(highRange\) does not pass the type constraint/);

eval { WWW::Google::CustomSearch->new({api_key=>$api_key, hl=>'xyz'}); };
like($@, qr/Attribute \(hl\) does not pass the type constraint/);

eval { WWW::Google::CustomSearch->new({api_key=>$api_key, imgColorType=>'xyz'}); };
like($@, qr/Attribute \(imgColorType\) does not pass the type constraint/);

eval { WWW::Google::CustomSearch->new({api_key=>$api_key, imgDominantColor=>'xyz'}); };
like($@, qr/Attribute \(imgDominantColor\) does not pass the type constraint/);

eval { WWW::Google::CustomSearch->new({api_key=>$api_key, imgSize=>'xyz'}); };
like($@, qr/Attribute \(imgSize\) does not pass the type constraint/);

eval { WWW::Google::CustomSearch->new({api_key=>$api_key, imgType=>'xyz'}); };
like($@, qr/Attribute \(imgType\) does not pass the type constraint/);

eval { WWW::Google::CustomSearch->new({api_key=>$api_key, lowRange=>'x'}); };
like($@, qr/Attribute \(lowRange\) does not pass the type constraint/);

eval { WWW::Google::CustomSearch->new({api_key=>$api_key, lr=>'x'}); };
like($@, qr/Attribute \(lr\) does not pass the type constraint/);

eval { WWW::Google::CustomSearch->new({api_key=>$api_key, rights=>'x'}); };
like($@, qr/Attribute \(rights\) does not pass the type constraint/);

eval { WWW::Google::CustomSearch->new({api_key=>$api_key, searchType=>'x'}); };
like($@, qr/Attribute \(searchType\) does not pass the type constraint/);

eval { WWW::Google::CustomSearch->new({api_key=>$api_key, siteSearchFilter=>'x'}); };
like($@, qr/Attribute \(siteSearchFilter\) does not pass the type constraint/);