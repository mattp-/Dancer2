my @expected = qw(
  after
  any
  before
  before_template
  cookie
  cookies
  config
  content_type
  dance
  debug
  del
  dirname
  error
  engine
  false
  forward
  from_dumper
  from_json
  from_yaml
  from_xml
  get
  halt
  header
  headers
  hook
  layout
  load
  load_app
  logger
  mime
  options
  param
  params
  pass
  path
  post
  prefix
  push_header
  put
  redirect
  render_with_layout
  request
  send_file
  send_error
  set
  setting
  set_cookie
  session
  splat
  status
  start
  template
  to_dumper
  to_json
  to_yaml
  to_xml
  true
  upload
  captures
  uri_for
  var
  vars
  warning
);

use Dancer;
my @done = @Dancer::EXPORT;

my $target = scalar(@expected);
my $done   = scalar(@done);

use feature 'say';
my $percent = sprintf('%02.2f', ($done / $target * 100));
say "Dancer 2.0 is at $percent% ($done symbols supported on $target)";
