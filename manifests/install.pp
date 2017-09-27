class influxdb::install(
  $version,
){
  package { 'influxdb_rpm':
    name => 'influxdb',
    ensure   => installed,
    provider => 'rpm',
    source => "https://dl.influxdata.com/influxdb/releases/influxdb-${version}.x86_64.rpm"
  }
}
