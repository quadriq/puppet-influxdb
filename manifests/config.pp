#class to config influxdb
class influxdb::config(
    $config = {},
  ){

  $default_config = {
      'global' => {
        'reporting-disabled' => false,
        'bind-adress' => '127.0.0.1:8088',
      },
      'meta' => {
        'dir' => '/var/lib/influxdb/meta',
        'retention-autocreate' => true,
        'logging-enabled' => true,
      },
      'data' => {
        'dir' => '/var/lib/influxdb/data',
        'wal_dir' => '/var/lib/influxdb/wal',
        'wal-fsync-delay' => '0s',
        'index-version' => 'inmem',
        'trace-logging-enabled' => false,
        'query-log-enabled' => true,
      },
      'retention' => {
        'enabled' => true,
        'check-interval' => '30m',
      },
      'http' => {
        'enabled' => true,
        'bind-address' => ':8086',
        'auth-enabled' => false,
        'realm' => 'InfluxDB',
        'log-enabled' => true,
        'write-tracing' => false,
        'pprof-enabled' => true,
        'https-enabled' => false,
        'https-certificate' => '/etc/ssl/influxdb.pem',
        'https-private-key' => '',
        'shared-secret' => '',
        'max-row-limit' => 0,
        'max-connection-limit' => 0,
        'unix-socket-enabled' => false,
        'bind-socket' => '/var/run/influxdb.sock',
      },
  }

  # Determines whether retention policy enforcement enabled.
  # enabled = true

  # The interval of time when retention policy enforcement checks run.
  # check-interval = "30m"

  $final_config = deep_merge($default_config, $config)

  file {'/etc/influxdb/influxdb.conf':
    content => template('influxdb/influxdb.conf.erb'),
    notify  => Service['influxd']
  }
}
