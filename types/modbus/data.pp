#
type Collectd::Modbus::Data = Struct[{Optional['instance'] => String, NotUndef['type'] => String[1], NotUndef['register_base'] => Numeric, NotUndef['register_type'] => String[1]}]
