# class to install influxdb
class influxdb::install(
  $version,
){

  file { 'influx.repo':
        ensure => file,
        path   => '/etc/yum.repos.d/influx.repo',
        source => 'puppet:///modules/influxdb/influx.repo',
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
  } ->
    
  package { 'influxdb':
    ensure   => installed,
  }
}
