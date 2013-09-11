require 'fog'
class UsersProvider
  requires :credentials

  def value
    options = {
      :rackspace_username => credentials.username,
      :rackspace_api_key  => credentials.api_key,
      :rackspace_region   => credentials.rackspace_region
    }
    Fog::Rackspace::Databases.new(options).users
  end
end
