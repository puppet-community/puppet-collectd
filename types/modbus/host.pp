#
type Collectd::Modbus::Host = Struct[{NotUndef['address'] => String[1], NotUndef['port'] => String[1], NotUndef['slaves'] => Hash[Integer, Collectd::Modbus::Slave], Optional['interval'] => Integer[0]}]
