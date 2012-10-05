use Test::More import => ['!pass'];
use strict;
use warnings;

BEGIN {
    use Module::Runtime qw/use_module/;
    plan skip_all => "Plack is needed to run this test"
      unless use_module('Plack::Request');
    use Dancer ':syntax';
}

plan tests => 7;

Module::Runtime qw/use_module/->require('Dancer::Handler::PSGI');

my $handler = Dancer::Handler::PSGI->new();

my %ENV = (
    REQUEST_METHOD  => 'GET',
    PATH_INFO       => '/',
    HTTP_ACCEPT     => 'text/html',
    HTTP_USER_AGENT => 'test::more',
);

$handler->init_request_headers( \%ENV );

my $app = sub {
    my $env     = shift;
    my $request = Dancer::Core::Request->new( env => \%ENV );
    $handler->handle_request($request);
};

set 'plack_middlewares' => [['Runtime']], 'public' => '.';

ok $app = $handler->apply_plack_middlewares($app);
my $res = $app->( \%ENV );
is $res->[0], 404;
ok grep { /X-Runtime/ } @{ $res->[1] };

ok $handler = Dancer::Handler::PSGI->new();
ok $app = $handler->dance;
$res = $app->(\%ENV);
is $res->[0], 404;

is ref $app, 'CODE';
