require 'json'


Puppet::Type.type(:influx_user).provide :ruby do

  def auth_data
    user_str = ""
    if resource[:superuser]
      user_str = " -username #{resource["superuser"]} -password #{resource["superpass"]} "
    end
    user_str
  end
 
  def exists?
    sleep(20)

    if !resource[:admin] and resource[:database] == :undef
      raise ArgumentError, "User %s should belong to database. Database is not defined" % resource[:name]
    end

    dbcmd =  `influx #{auth_data} -execute 'SHOW USERS' -format json`
    dbjson = JSON.parse(dbcmd)
    if dbjson["results"][0]["series"][0]["values"].any? { |i| i[0] == resource[:name] and i[1].to_s.downcase == resource[:admin].to_s.downcase}
      return true
    end
    false
  end

  def create

    # CREATE USER "jdoe" WITH PASSWORD '1337password' WITH ALL PRIVILEGES
    if resource[:admin]
      `influx #{auth_data} -execute "CREATE USER #{resource[:name]} WITH PASSWORD '#{resource[:password]}' WITH ALL PRIVILEGES"`
    else
      `influx #{auth_data} -execute "CREATE USER #{resource[:name]} WITH PASSWORD '#{resource[:password]}'"`
      `influx #{auth_data} -execute "GRANT #{resource[:privileges]} ON #{resource[:database]} TO #{resource[:name]}"`
    end

  end

  def destroy
    `influx -execute 'DROP USER #{resource[:name]}'`
  end

end
