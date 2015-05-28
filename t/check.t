#!perl
use strict;
use warnings;

use lib qw(../lib/ );

use File::Spec;


use Test::More;

my $class = 'File::Name::Check';

use_ok($class);

my $object = new_ok($class);

ok($object->new());
ok($object->new(1,2));
ok($object->new({}));
ok($object->new({a => 1}));

ok($object->safechars(__FILE__),'safechars');
ok(!$object->safechars(' '),'not safechars');
ok($object->locale(__FILE__),'locale');
ok($object->encoded(__FILE__,'UTF-8'),'encoded');

my $path = File::Spec->rel2abs();

ok($object->caseunique($path),'caseunique');
ok($object->caseunique('a',qw( a b)),'caseunique (a b)');
ok(!$object->caseunique('a',qw( a A )),'caseunique(a A)');

ok($object->paranoic('a',qw( a b)),'paranoic (a b)');
ok(!$object->paranoic('?',qw(? a) ),'paranoic');
ok(!$object->paranoic("\x{FC}a","\x{FC}a","\x{FC}A"),'paranoic');
ok(!$object->paranoic("a","a","A"),'paranoic');

ok($object->paranoic($path),'paranoic');

ok(!$object->_reencode("\xFC",'UTF-8'),'_reencode \xFC');

done_testing;
