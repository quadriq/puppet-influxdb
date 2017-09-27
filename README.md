# Puppet InfluxDB

Puppet Module to setup and manage `influxdb` installation and resources.

> Under Development! Currently very limited functionality: support of EL-Linux(CentOs, SciLi.) and some build-in ruby functions. Welcome Contribution!

## Quick Start

install and start InfluxDb service.

```
class {'influxdb':}

or in hiera

classes:
 - influxdb
```

## Class Parameter

> note, not all parameters are introduced right now,  Welcome Contribution!

see `manifests/config.pp` for supported parameters. Otherwise you can do:

```puppet
$parameter =
{ 'global' =>
  {
    'reporting-disabled' => true,
    'bind-adress' => '127.0.0.1:8088',
  },
  'http' =>
  {
    'bind-address' => ':8086'
  }
}

class{'influxdb':
  config => $parameter,
}
```

or in hiera:

```
influxdb::config:
  global:
    reporting-disabled: true
  http:
    bind-address: ':8086'
```

## Custom resource-types

### influx_database

create database

```puppet
influx_database{"testme2":
}
```

### influx_user

parameter

* `name` - namevar, name of the user
* `password` - password
* `admin` - if the user is admin, default to `false`
* `database` - on which database grant privileges, relevant only for non-admin users. Requires database to be created.
* `privileges` - privileges to grant, default to `'ALL'`

```puppet
influx_user{"homer":
     password => "marge",
     ensure => present,
     database => "testme2"
}
```
