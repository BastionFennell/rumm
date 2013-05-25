require 'netrc'

class CredentialsProvider

  def value
    if creds = Netrc.read['api.rackspace.com']
      Map(username: creds.first, api_key: creds.last)
    else
      fail Rax::LoginRequired, "login required"
    end
  end
end
