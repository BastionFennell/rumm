require "net/https"
require "json"
require "netrc"
require "excon"

class AuthenticationController < MVCLI::Controller

  requires :user

  def login
    login_info = user
    username = login_info.name
    password = login_info.password

    connection = Excon.new('https://identity.api.rackspacecloud.com')

    headers = {'Content-Type' => 'application/json'}
    body = {auth: {passwordCredentials: {username: username, password: password}}}

    response = connection.post headers: headers, body: body.to_json, path: '/v2.0/tokens'

    #TODO check the status code of the request
    user_info = Map(JSON.parse response.body)

    #Test if it's authenticated
    fail "User could not be authenticated" unless user_info[:access]

    headers.merge!({'X-Auth-Token' => user_info.access.token.id})
    response = connection.get headers: headers, path: "/v2.0/users/#{user_info.access.user.id}/OS-KSADM/credentials/RAX-KSKEY:apiKeyCredentials"

    user_credentials = Map(JSON.parse response.body)

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
