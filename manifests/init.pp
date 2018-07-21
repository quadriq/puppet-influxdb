# class dbinflux
class influxdb(
  $config  = {},
  $config_template = 'influxdb/influxdb.conf.erb',
  $auth_enabled = false,
  $auth_superuser = undef,
  $auth_superpass = undef,
  $package_ensure = 'installed'
) {

  if ($auth_enabled){
    $auth_config = {
      'http' => {
        'enabled' => true,
        'auth-enabled' => true,
      }
    }
    $mconfig = deep_merge($config, $auth_config)
  } else {
    $mconfig = deep_merge($config, {})
  }

  class{'influxdb::install':
    package_ensure => $package_ensure,
  } ->

  class{'influxdb::config':
    config => $mconfig,
    config_template => $config_template,
  } ->

  service {'influxd':
    ensure => 'running',
    enable => true,
  }

  if ($auth_enabled){
    influx_config_auth{"config-auth":
      superuser => $auth_superuser,
      superpass => $auth_superpass
    }
  }
}
