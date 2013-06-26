require 'netrc'

class CredentialsProvider

  def value
    if creds = Netrc.read['api.rackspace.com']
      Map(username: creds.first, api_key: creds.last, rackspace_region: :ord)
    else
      fail Rumm::LoginRequired, "login required"
    end
  end
end
