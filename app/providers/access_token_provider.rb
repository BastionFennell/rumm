class AccessTokenProvider
  requires :credentials

  def value
    connection = Excon.new('https://identity.api.rackspacecloud.com')

    headers = {'Content-Type' => 'application/json'}
    body = {auth: {'RAX-KSKEY:apiKeyCredentials' => {username: credentials.username, apiKey: credentials.api_key}}}

    response = connection.post headers: headers, body: body.to_json, path: '/v2.0/tokens'
    c = Map(JSON.parse response.body)
    c.access.token.id
  end
end