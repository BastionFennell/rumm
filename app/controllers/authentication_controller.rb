require 'net/https'
require 'json'
require 'netrc'

class AuthenticationController < MVCLI::Controller

  requires :user

  def login
    #Check if they're already logged in
    #if(they're logged in)
    # prompt("you sure bout that?")
    login_info = user
    username = login_info.name
    password = login_info.password

    uri = URI('https://identity.api.rackspacecloud.com/v2.0/tokens')
    req = Net::HTTP::Post.new(uri)
    req['Content-Type'] = 'application/json'
    req.body = {auth: {passwordCredentials: {username: username, password: password}}}.to_json
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |https|
      https.request req
    end

    #TODO check the status code of the request
    user_info = Map(JSON.parse res.body)

    uri = URI("https://identity.api.rackspacecloud.com/v2.0/users/#{user_info.access.user.id}/OS-KSADM/credentials/RAX-KSKEY:apiKeyCredentials")
    req = Net::HTTP::Get.new(uri, initheader = {'X-Auth-Token' => user_info.access.token.id})
    req['Content-Type'] = 'application/json'
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |https|
      https.request req
    end

    user_credentials = Map(JSON.parse res.body)

    netrc = Netrc.read
    netrc['api.rackspace.com'] = username, user_credentials["RAX-KSKEY:apiKeyCredentials"].apiKey
    netrc.save

    user_info
  end

  def logout
    n = Netrc.read
    n.delete 'api.rackspace.com'
    n.save
  end
end
