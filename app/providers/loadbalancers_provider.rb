require 'fog'
class LoadbalancersProvider
  requires :credentials

  def value
    options = {
      :rackspace_username   => credentials.username,
      :rackspace_api_key    => credentials.api_key,
      :rackspace_region     => credentials.rackspace_region,
      :connection_options => {:headers => {"User-Agent" => "rumm/#{Rumm::VERSION} fog/#{Fog::VERSION}"}}
    }
    Fog::Rackspace::LoadBalancers.new(options).load_balancers
  end
end
