Puppet::Type.newtype(:influx_config_auth) do
  @doc = "Config HTTP auth"
  ensurable

  newparam(:name, :namevar => true) do
    desc "some generic name, doesn't really metter"
  end

  newparam(:superuser) do
    desc "Password"
  end

  newparam(:superpass) do
    desc "Enable or Disable http-auth"
  end

end
