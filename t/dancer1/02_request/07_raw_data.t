use Test::More import => ['!pass'];
use strict;
use warnings;
use Module::Runtime qw/use_module/;
use Dancer;
use File::Spec;
use lib File::Spec->catdir( 't', 'lib' );

plan skip_all => "skip test with Test::TCP in win32" if $^O eq 'MSWin32';
plan skip_all => "Test::TCP is needed for this test"
    unless use_module("Test::TCP" => "1.13");

use LWP::UserAgent;

use constant RAW_DATA => "var: 2; foo: 42; bar: 57\nHey I'm here.\r\n\r\n";

plan tests => 2;
Test::TCP::test_tcp(
    client => sub {
        my $port = shift;
        my $rawdata = RAW_DATA;
        my $ua = LWP::UserAgent->new;
        my $req = HTTP::Request->new(PUT => "http://127.0.0.1:$port/jsondata");
        my $headers = { 'Content-Length' => length($rawdata) };
        $req->push_header($_, $headers->{$_}) foreach keys %$headers;
        $req->content($rawdata);
        my $res = $ua->request($req);

        ok $res->is_success, 'req is success';
        is $res->content, $rawdata, "raw_data is OK";
    },
    server => sub {
        my $port = shift;

        use TestApp;
        Dancer::Config->load;

        set( environment  => 'production',
             port         => $port,
             startup_info => 0);
        Dancer->dance();
    },
);
