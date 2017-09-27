require 'json'

Puppet::Type.type(:influx_database).provide :ruby do

  def destroy
    `influx -execute 'DROP DATABASE #{resource[:name]}'`
  end

  def create
    `influx -execute 'CREATE DATABASE #{resource[:name]}'`
  end

  def exists?
    dbcmd =  `influx -execute 'SHOW DATABASES' -format json`
    dbjson = JSON.parse(dbcmd)
    if dbjson["results"][0]["series"][0]["values"].any? { |i| i.include? resource[:name] }
      return true
    end
    false
  end

end
