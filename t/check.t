#!perl
use strict;
use warnings;

use lib qw(../lib/ );

use Test::More;

my $class = 'File::Name::Check';

use_ok($class);

my $object = new_ok($class);

ok($object->new());
ok($object->new(1,2));
ok($object->new({}));
ok($object->new({a => 1}));

ok($object->safechars(__FILE__),'safechars');
ok($object->locale(__FILE__),'locale');
ok($object->encoded(__FILE__,'UTF-8'),'encoded');

#my $path = __FILE__;
#ok($object->caseunique('./'),'caseunique');

done_testing;
