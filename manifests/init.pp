# class dbinflux
class influxdb(
  $version = '1.3.4',
  $config  = {}
) {

  class{'influxdb::install':
    version => $version,
  } ->

  class{'influxdb::config':
    config => $config,
  } ->


  # exec{'install_influxdb_gem':
  #    command => '/bin/gem install influxdb -v 0.3.16',
  #    unless  => '/bin/gem list | grep influxdb'
  # }

  service {'influxd':
    ensure => 'running',
    enable => true,
  }
}
