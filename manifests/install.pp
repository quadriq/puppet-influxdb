# class to install influxdb
#
# @summary Installs the yum repository and package for influxdb
#
# @param manage_package Whether this module should manage the package installation.
# @param manage_repo Whether the repository is managed by this module or not.
# @param package_ensure Either 'absent' or 'latest' or a specific version number.
# @param repo_ensure Set to 'present' (default) to install or to 'absent' to remove the repository.
class influxdb::install(
  $manage_package,
  $manage_repo,
  $package_ensure,
  $repo_ensure,
){

  if $manage_repo {
    yumrepo { 'influxdb':
      ensure   => $repo_ensure,
      baseurl  => 'https://repos.influxdata.com/centos/\$releasever/\$basearch/stable',
      enabled  => true,
      gpgcheck => true,
      gpgkey   => ' https://repos.influxdata.com/influxdb.key',
    }
    $package_require = Yumrepo['influxdb']
  } else {
    $package_require = []
  }

  if $manage_package {
    package { 'influxdb':
      ensure  => $package_ensure,
      require => $package_require,
    }
  }
}
