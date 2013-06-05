require 'fog'
class NodesProvider
  requires :credentials

  def value
    options = {
      :rackspace_username => credentials.username,
      :rackspace_api_key  => credentials.api_key,
      :rackspace_region   => credentials.rackspace_region
    }
    Fog::Rackspace::LoadBalancers.new(options).nodes
  end
end
