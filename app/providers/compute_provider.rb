require 'fog'
class ComputeProvider
  requires :credentials

  def value
    options = {
      :provider            => 'Rackspace',
      :rackspace_username  => credentials.username,
      :rackspace_api_key   => credentials.api_key,
      :version             => :v2
    }
    Fog::Compute.new(options)
  end
end
