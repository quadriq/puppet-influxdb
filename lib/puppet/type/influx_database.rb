Puppet::Type.newtype(:influx_database) do
  @doc = "Manages Databases"
  ensurable

  newparam(:name, :namevar => true) do
    desc "name of user account"
  end

  newparam(:superuser) do
    desc "Auth superuser"
    defaultto(:undef)
  end

  newparam(:superpass) do
    desc "Auth superpass"
    defaultto(:undef)
  end
  
end
