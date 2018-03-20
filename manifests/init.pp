# class dbinflux
class influxdb(
  $version = '1.3.4',
  $config  = {},
  $auth_enabled = false,
  $auth_superuser = undef,
  $auth_superpass = undef,
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
    version => $version,
  } ->

  class{'influxdb::config':
    config => $mconfig,
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
