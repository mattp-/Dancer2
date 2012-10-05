use strict;
use warnings;
use Test::More tests => 6;

BEGIN { use_ok 'Module::Runtime qw/use_module/' }

ok( use_module("File::Spec"), "File::Spec is loaded" );
ok( File::Spec->rel2abs('.'), "File::Spec is imported" );
ok( !use_module("Non::Existent::Module"), "fake module is not loaded" );

ok( use_module("File::Spec", "1.0"), "File::Spec version >= 1.0 is loaded");
ok( !use_module("File::Spec", "9999"), "Can't load File::Spec v9999");
