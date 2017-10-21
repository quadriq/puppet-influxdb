# Puppet InfluxDB

Puppet Module to setup and manage `influxdb` installation and resources.

> Under Development! Currently very limited functionality: support of EL-Linux(CentOs) and some build-in ruby functions. Welcome Contribution!

## Quick Start

install and start InfluxDb service.

```
class {'influxdb':}

or in hiera

classes:
 - influxdb
```

## InfluxDB config Parameter

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

## Enable http-auth

by design, influxdb needs an "admin" user before you can enable http-auth in influxdb-config. So in order to manage this with puppet we need to pass "admin" creadentials to the influx class.. we would call this admin user - __superuser__

so call it like:

```
class {"influxdb":
  auth_enabled => true,
  auth_superuser => 'john',
  auth_superpass => 'lennon',
}
```

## Custom resource-types

### influx_database

create database

parameter

* `superuser` - by http-auth enabled, pass the admin user name
* `superpass` - by http-auth enabled, pass the admin user password

```puppet
influx_database{"testme2":
}
```

or if you use http-auth

```puppet
influx_database{"testme2":
  superuser => 'john',
  superpass => 'lennon'
}
```

### influx_user

parameter

* `name` - namevar, name of the user
* `password` - password
* `admin` - if the user is admin, default to `false`
* `database` - on which database grant privileges, relevant only for non-admin users. Requires database to be created.
* `privileges` - privileges to grant, default to `'ALL'`
* `superuser` - by http-auth enabled, pass the admin user name
* `superpass` - by http-auth enabled, pass the admin user password

```puppet
influx_user{"homer":
     password => "marge",
     ensure => present,
     database => "testme2"
}
```

## Notable

* all custom resources have 20sec delay, in order to wait for influxdb to startup, if it was restarted just before.
