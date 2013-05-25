require 'net/https'
require 'json'

class AuthenticationController

  requires :console

  def login
#    username = console.ask "username: "
 #   password = console.ask_passord "password:"
    uri = URI('https://identity.api.rackspacecloud.com/v2.0/tokens')
    req = Net::HTTP::Post.new(uri)
    req['Content-Type'] = 'application/json'
    req.body = {auth: {passwordCredentials: {username: username, password: password}}}.to_json
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |https|
      https.request req
    end
    Map(JSON.parse res.body)

  end

  def logout
    Object.new
  end
end
