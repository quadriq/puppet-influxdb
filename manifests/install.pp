# class to install influxdb
class influxdb::install(
  $version,
){
  package { 'influxdb_rpm':
    ensure   => installed,
    name     => 'influxdb',
    provider => 'rpm',
    source   => "https://dl.influxdata.com/influxdb/releases/influxdb-${version}.x86_64.rpm"
  }
}
