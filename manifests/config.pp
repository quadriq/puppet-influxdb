#class to config influxdb
class influxdb::config(
    $config = {},
    $config_template = 'influxdb/influxdb.conf.erb',
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
        'cache-max-memory-size' => 1048576000,
        'cache-snapshot-memory-size' => 26214400,
        'cache-snapshot-write-cold-duration' => '10m',
        'compact-full-write-cold-duration' => '4h',
        'max-concurrent-compactions' => 0,
        'max-series-per-database' => 1000000,
        'max-values-per-tag' => 100000,
      },
      'coordinator' => {
        'write-timeout' => '10s',
        'coordinator' => 0,
        'query-timeout' => '0s',
        'log-queries-after' => '0s',
        'max-select-point' => 0,
        'max-select-series' => 0,
        'max-select-buckets' => 0,
        'max-concurrent-queries' => 0,
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
      'udp' => {
        'enabled' => false,
        'bind-address' => ':8089',
        'database' => 'udp',
        'retention-policy' => '',
        'batch-size' => '5000',
        'batch-pending' => 10,
        'batch-timeout' => '1s',
        'read-buffer' => 0
      },
      'graphite' => {
        'enabled' => false,
        'database' => 'graphite',
        'retention-policy' => '',
        'bind-address' => ':2003',
        'protocol' => 'tcp',
      },
  }

  $final_config = deep_merge($default_config, $config)

  file {'/etc/influxdb/influxdb.conf':
    content => template($config_template),
    notify  => Service['influxd']
  }
}
