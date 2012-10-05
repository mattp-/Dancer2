use Test::More import => ['!pass'];
use strict;
use warnings;

use Dancer ':syntax';
use Module::Runtime qw/use_module/;
use LWP::UserAgent;

use File::Spec;
use lib File::Spec->catdir('t','lib');

plan skip_all => "skip test with Test::TCP in win32" if $^O eq 'MSWin32';
plan skip_all => "Test::TCP is needed for this test"
  unless use_module("Test::TCP" => "1.13");
plan skip_all => "Plack is needed to run this test"
  unless use_module('Plack::Request');

use_module('Plack::Loader');

my $confs = { '/hash' => [['Runtime']], };

my @tests =
  ( { path => '/', runtime => 0 }, { path => '/hash', runtime => 1 } );

plan tests => (2 * scalar @tests);

Test::TCP::test_tcp(
    client => sub {
        my $port = shift;
        my $ua   = LWP::UserAgent->new;

        foreach my $test (@tests) {
            my $req =
              HTTP::Request->new(
                GET => "http://localhost:$port" . $test->{path} );
            my $res = $ua->request($req);
            ok $res;
            if ( $test->{runtime} ) {
                ok $res->header('X-Runtime');
            }
            else {
                ok !$res->header('X-Runtime');
            }
        }
    },
    server => sub {
        my $port = shift;

        use TestApp;
        Dancer::Config->load;

        set( environment           => 'production',
             apphandler            => 'PSGI',
             port                  => $port,
             startup_info          => 0,
             plack_middlewares_map => $confs );

        my $app = Dancer::Handler->get_handler()->dance;
        Plack::Loader->auto( port => $port )->run($app);
    },
);
