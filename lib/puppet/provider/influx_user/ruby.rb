require 'json'


Puppet::Type.type(:influx_user).provide :ruby do


  def exists?
    if !resource[:admin] and resource[:database] == :undef
      raise ArgumentError, "User %s should belong to database. Database is not defined" % resource[:name]
    end

    dbcmd =  `influx -execute 'SHOW USERS' -format json`
    dbjson = JSON.parse(dbcmd)
    if dbjson["results"][0]["series"][0]["values"].any? { |i| i[0] == resource[:name] and i[1] == resource[:admin]}
      return true
    end
    false
  end

  def create
    # CREATE USER "jdoe" WITH PASSWORD '1337password' WITH ALL PRIVILEGES
    if resource[:admin]
      `influx -execute "CREATE USER #{resource[:name]} WITH PASSWORD '#{resource[:password]}' WITH ALL PRIVILEGES"`
    else
      `influx -execute "CREATE USER #{resource[:name]} WITH PASSWORD '#{resource[:password]}'"`
      `influx -execute "GRANT #{resource[:privileges]} ON #{resource[:database]} TO #{resource[:name]}"`
    end

  end

  def destroy
    `influx -execute 'DROP USER #{resource[:name]}'`
  end

end
