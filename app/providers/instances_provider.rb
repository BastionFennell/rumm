require 'fog'
class InstancesProvider
  requires :credentials

  def value
    options = {
      :rackspace_username => credentials.username,
      :rackspace_api_key  => credentials.api_key,
      :rackspace_region   => credentials.rackspace_region
    }
    Fog::Rackspace::Databases.new(options).instances
  end
end
