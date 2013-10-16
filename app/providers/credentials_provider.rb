class CredentialsProvider
  
  requires :configuration

  def value
    if configuration.username
      Map(username: configuration.username, api_key: configuration.api_key, rackspace_region: configuration.region)
    else
      fail Rumm::LoginRequired, "login required"
    end
  end
end
