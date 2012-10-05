use Test::More import => ['!pass'];

use strict;
use warnings;

use Dancer ':syntax';
use Module::Runtime qw/use_module/;

plan tests => 9;

my $struct = {eris => 23};

SKIP: {
    skip 'YAML is needed to run this test', 3
      unless use_module('YAML');
    ok my $test         = to_yaml($struct), 'to yaml';
    ok my $final_struct = from_yaml($test), 'from yaml';
    is_deeply $final_struct, $struct, 'from => to works';

}

SKIP: {
    skip 'JSON is needed to run this test', 3
      unless use_module('JSON');
    ok my $test         = to_json($struct), 'to json';
    ok my $final_struct = from_json($test), 'from json';
    is_deeply $final_struct, $struct, 'from => to works';

}

SKIP: {
    skip 'XML::Simple is needed to run this test', 3
      unless use_module('XML::Simple');

    skip 'XML::Parser or XML::SAX are needed to run this test', 3
        unless use_module('XML::Parser') or
               use_module('XML::SAX');

    ok my $test         = to_xml($struct), 'to xml';
    ok my $final_struct = from_xml($test), 'from xml';
    is_deeply $final_struct, $struct, 'from => to works';
}
