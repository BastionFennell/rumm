require 'net/https'
require 'json'
require 'netrc'

class AuthenticationController < MVCLI::Controller

  requires :user

  def login
    #Check if the .netrc is already in use
    #if(.netrc is in use)
    # prompt("you sure bout that?")
    # set boolean to true or false
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
    user_info = Map(JSON.parse res.body)

    uri = URI("https://identity.api.rackspacecloud.com/v2.0/users/#{user_info.access.user.id}/OS-KSADM/credentials/RAX-KSKEY:apiKeyCredentials")
    req = Net::HTTP::Get.new(uri, initheader = {'X-Auth-Token' => user_info.access.token.id})
    req['Content-Type'] = 'application/json'
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |https|
      https.request req
    end

    user_credentials = Map(JSON.parse res.body)

    write_to_rc username, user_credentials["RAX-KSKEY:apiKeyCredentials"].apiKey, true

    user_info

    #Write to .netrc

  end

  def logout
    if n = Netrc.read
      name, pass = n["api.rackspace.com"]
      if name != "logout" and pass != "logout"
        n["api.rackspace.com"] = "logout", "logout"
        n.save
      else
        fail Rax::LoginRequired, "You must log in before you can log out"
      end
    else
      fail Rax::LoginRequired, "You must log in before you can log out"
    end
  end

  private

  def write_to_rc name, key, overwrite
    n = Netrc.read
    n["api.rackspace.com"] = name, key
    n.save
  end
end
