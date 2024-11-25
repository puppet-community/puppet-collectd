# @summary Creates configuration for a collectd modbus plugin
#
# More information on the modbus plugin configuration options:
# https://collectd.org/wiki/index.php/Plugin:Modbus
#
# @example
#
# class {'collectd::plugin::modbus':
#   ensure => 'present',
#   data   =>  {
#     current_phase_a => {
#       'type'          => 'gauge',
#       'instance'      => 'current phase A',
#       'register_base' => 1234,
#       'register_type' => 'Float',
#     }
#   },
#   hosts  => {
#     meter123 => {
#       'address'   => '127.0.0.1',
#       'port'      => '502',
#       'interval'  => 10,
#       'slaves'    => {
#         255 => {
#           'instance' => 'power meter 255',
#           'collect'  => ['current_phase_a'],
#         }
#       },
#     }
#   },
# }
#
# @param ensure
#   Ensures modbus module
# @param manage_package
#   If enabled, install required packages
# @param data
#   Defines data set configuration
# @param hosts
#   Defines hosts configuration

class collectd::plugin::modbus (
  Enum['present', 'absent']               $ensure         = 'present',
  Optional[Boolean]                       $manage_package = undef,
  Hash[String[1], Collectd::Modbus::Data] $data           = {},
  Hash[String[1], Collectd::Modbus::Host] $hosts          = {},
) {
  include collectd

  $_manage_package = pick($manage_package, $collectd::manage_package)

  if $facts['os']['family'] == 'RedHat' {
    if $_manage_package {
      package { 'collectd-modbus':
        ensure => $ensure,
      }
    }
  }

  if $facts['os']['family'] == 'Debian' {
    if $_manage_package {
      package { 'libmodbus5':
        ensure => $ensure,
      }
    }
  }

  collectd::plugin { 'modbus':
    ensure   => $ensure,
    content  => template('collectd/plugin/modbus.conf.erb'),
  }
}
