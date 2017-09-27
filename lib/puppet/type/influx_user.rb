Puppet::Type.newtype(:influx_user) do
  @doc = "Manages User Accounts"
  ensurable

  newparam(:name, :namevar => true) do
    desc "name of user account"
  end

  newparam(:password) do
    desc "Password"
  end

  newparam(:admin) do
    desc "if admin or not"
    defaultto false
  end

  newparam(:database) do
    desc "User Database"
    defaultto(:undef)
  end

  newparam(:privileges) do
    desc "Priveleges"
    defaultto 'ALL'
  end

end
