# class influxdb
#
# @summary Managing influxdb
#
# @param config configuration hash for influxdb
# @param config_template Template for the influxdb configuration
# @param auth_enabled Enable user authentication
# @param auth_superuser Mandatory superuser if auth_enabled is set to true
# @param auth_superpass Password for superuser if authentication is enabled
# @param manage_package Whether this module should manage the package installation.
# @param manage_repo Whether the repository is managed by this module or not.
# @param package_ensure Either 'absent' or 'latest' or a specific version number.
# @param repo_ensure Set to 'present' (default) to install or to 'absent' to remove the repository.
class influxdb(
  $config  = {},
  $config_template = 'influxdb/influxdb.conf.erb',
  $auth_enabled = false,
  $auth_superuser = undef,
  $auth_superpass = undef,
  $manage_package = true,
  $manage_repo    = true,
  $package_ensure = 'installed',
  $repo_ensure    = 'present',
  $service_name   = 'influxdb'
  $service_ensure = 'running',
  $service_enable = true,
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
    manage_package => $manage_package,
    manage_repo    => $manage_repo,
    package_ensure => $package_ensure,
    repo_ensure    => $repo_ensure,
  } ->

  class{'influxdb::config':
    config => $mconfig,
    config_template => $config_template,
  } ->

  service {$service_name:
    ensure => $service_ensure,
    enable => $service_enable,
  }

  if ($auth_enabled){
    influx_config_auth{"config-auth":
      superuser => $auth_superuser,
      superpass => $auth_superpass
    }
  }
}
