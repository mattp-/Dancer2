use strict;
use warnings;
use Test::More import => ['!pass'];

use Dancer::Core::Request;

plan tests => 3;

$ENV{REQUEST_METHOD} = 'DELETE';
$ENV{PATH_INFO} = '/';

my $req = Dancer::Core::Request->new(env => \%ENV);
is $req->path, '/', 'path is set';
is $req->method, 'DELETE', 'method is delete';
ok $req->is_delete, 'request is delete';
