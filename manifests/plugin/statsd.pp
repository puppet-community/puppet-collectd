# https://collectd.org/wiki/index.php/Plugin:StatsD
class collectd::plugin::statsd (
  $ensure = undef
  $host            = undef,
  $port            = undef,
  $deletecounters  = undef,
  $deletetimers    = undef,
  $deletegauges    = undef,
  $deletesets      = undef,
  $interval        = undef,
  $timerpercentile = undef,
  $timerlower      = undef,
  $timerupper      = undef,
  $timersum        = undef,
  $timercount      = undef,
) {

  include ::collectd

  collectd::plugin { 'statsd':
    ensure   => $ensure_real,
    content  => template('collectd/plugin/statsd.conf.erb'),
    interval => $interval,
  }
}
