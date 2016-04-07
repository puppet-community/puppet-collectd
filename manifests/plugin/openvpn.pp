# https://collectd.org/wiki/index.php/Plugin:OpenVPN
class collectd::plugin::openvpn (
  $ensure = undef
  $statusfile             = '/etc/openvpn/openvpn-status.log',
  $improvednamingschema   = false,
  $collectcompression     = true,
  $collectindividualusers = true,
  $collectusercount       = false,
  $interval               = undef,
) {

  include ::collectd

  if is_string($statusfile) {
    validate_absolute_path($statusfile)
    $statusfiles = [ $statusfile ]
  } elsif is_array($statusfile) {
    $statusfiles = $statusfile
  } else {
    fail("statusfile must be either array or string: ${statusfile}")
  }

  validate_bool(
    $improvednamingschema,
    $collectcompression,
    $collectindividualusers,
    $collectusercount,
  )

  collectd::plugin { 'openvpn':
    ensure   => $ensure_real,
    content  => template('collectd/plugin/openvpn.conf.erb'),
    interval => $interval,
  }
}
