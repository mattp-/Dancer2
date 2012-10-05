use Test::More import => ['!pass'];
use strict;
use warnings;
use Module::Runtime qw/use_module/;

plan skip_all => "skip test with Test::TCP in win32" if $^O eq 'MSWin32';
plan skip_all => "Test::TCP is needed to run this test"
    unless use_module('Test::TCP' => "1.13");
plan skip_all => "Plack is needed to run this test"
    unless use_module('Plack::Request');

use LWP::UserAgent;

use_module('Plack::Loader');

my $app = Dancer::Handler->psgi_app;

plan tests => 3;

Test::TCP::test_tcp(
    client => sub {
        my $port = shift;
        my $ua = LWP::UserAgent->new;

        my $res = $ua->get("http://127.0.0.1:$port/env");
        like $res->content, qr/psgi\.version/,
            'content looks good for /env';

        $res = $ua->get("http://127.0.0.1:$port/name/bar");
        like $res->content, qr/Your name: bar/,
            'content looks good for /name/bar';

        $res = $ua->get("http://127.0.0.1:$port/name/baz");
        like $res->content, qr/Your name: baz/,
            'content looks good for /name/baz';
    },
    server => sub {
        my $port = shift;

        use File::Spec;
        use lib File::Spec->catdir( 't', 'lib' );
        use TestApp;
        use Dancer;
        set apphandler  => 'PSGI', environment => 'production';
        Dancer::Config->load;

        Plack::Loader->auto(port => $port)->run($app);
    },
);
