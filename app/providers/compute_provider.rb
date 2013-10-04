require 'fog'
class ComputeProvider
  requires :credentials

  def value
    options = {
      :provider            => 'Rackspace',
      :rackspace_username  => credentials.username,
      :rackspace_api_key   => credentials.api_key,
      :version             => :v2,
      :rackspace_region    => credentials.rackspace_region,
      :connection_options => {:headers => {"User-Agent" => "rumm/#{Rumm::VERSION} fog/#{Fog::VERSION}"}}
    }
    Fog::Compute.new(options)
  end
end
