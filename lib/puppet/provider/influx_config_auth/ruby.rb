require 'json'

Puppet::Type.type(:influx_config_auth).provide :ruby do

  def exists?

    sleep(10)

    if !system("influx -username #{resource["superuser"]} -password '#{resource["superpass"]}' -execute ';'")
      p " > auth disabled, or superuser is wrong.. lets fix it"
      sleep(10)

      # stop influx and create conf backup
      p " > stopping #{resource[:servicename]}"
      `systemctl stop #{resource[:servicename]}`
      `/bin/cp -rf /etc/influxdb/influxdb.conf /tmp/influxdb.conf`

      # start influx with default config
      p " > start influx without auth and recreate superuser"
      #`influxdb config > /etc/influxdb/influxdb.conf`
      #`/bin/sed -i -e 's/\\/root\\/.influxdb/\\/var\\/lib\\/influxdb\\/i/g' /etc/influxdb/influxdb.conf`

      `sed -i 's/  auth-enabled.*/  auth-enabled = false/'  /etc/influxdb/influxdb.conf`
      `systemctl start #{resource[:servicename]}`
      sleep(20)

      p " > drop user '#{resource[:superuser]}', if exists"
      `influx -execute "DROP USER #{resource[:superuser]}"`

      p " > create user '#{resource[:superuser]}'"
      `influx -execute "CREATE USER #{resource[:superuser]} WITH PASSWORD '#{resource[:superpass]}' WITH ALL PRIVILEGES"`
      # restart influx with old config
      p " > restart influx and try again"
      `systemctl stop #{resource[:servicename]}`
      `mv /tmp/influxdb.conf /etc/influxdb/influxdb.conf`
      `chown influxdb:influxdb /etc/influxdb/influxdb.conf`
      `systemctl start #{resource[:servicename]}`
      sleep(20)

      # check again
      if !system("influx  -username #{resource["superuser"]} -password '#{resource["superpass"]}' -execute ';'")
        p " > auth still wrong :("
        return false
      else
        p " > auth configured"
        return true
      end
    else
      true
    end

    # dbcmd =  `influx -execute 'SHOW DATABASES' -format json`
    # dbjson = JSON.parse(dbcmd)
    # if dbjson["results"][0]["series"][0]["values"].any? { |i| i.include? resource[:name] }
    #   return true
    # end
    false
  end

  def destroy
    "destroyed"
  end

  def create
    "created"
  end

end
