require 'fog'

class ContainersProvider
  requires :credentials

  def value
    options = {
      :provider           => 'Rackspace',
      :rackspace_username => credentials.username,
      :rackspace_api_key  => credentials.api_key,
      :rackspace_region   => credentials.rackspace_region
    }
    Fog::Storage.new(options).directories
  end
end
