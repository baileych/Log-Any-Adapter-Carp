#!/usr/bin/env perl

use Test::More;
use Log::Any qw($log);
use Log::Any::Adapter;

Log::Any::Adapter->set('Carp', no_trace => 1, log_level => 'warn');

my $msg;
$SIG{__WARN__} = sub { $msg = shift; };

ok(!$log->info('Not logged'), "Don't log at too low a level");
ok(!defined $msg, 'Not logged below threshold');

ok($log->error('Is logged'), 'Log at appropriate level');
is($msg, "Is logged\n", 'Log message, no trace');

Log::Any::Adapter->set('Carp', log_level => 'info');

ok($log->info('Now logged'), 'Log at new appropriate level');
like($msg, qr{Now logged at .*basic.t}, 'Log message, with trace');

Log::Any::Adapter->set('Carp', log_level => 'info', full_trace => 1);

$log->info('Now logged');
like($msg, qr{Now logged at .*Log::Any::Adapter::Carp.*basic.t}s,
     'Log message, with trace');

done_testing();
