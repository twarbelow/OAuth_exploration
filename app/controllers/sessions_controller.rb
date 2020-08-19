class SessionsController < ApplicationController
  def create
    client_id = "123e0c64df1bf2ba4c4d"
    client_secret = "a46a77685956c5c6803113cf8dacb0dceb353d3a"
    code = params[:code]

    conn = Faraday.new(url: 'https://github.com', headers: {'Accept': 'application/json'})

    response = conn.post('/login/oauth/access_token') do |req|
      req.params['code'] = code
      req.params['client_id'] = client_id
      req.params['client_secret'] = client_secret
    end

    data = JSON.parse(response.body, symbolize_names: true)
    access_token = data[:access_token]

    conn = Faraday.new(
      url: 'https://api.github.com',
      headers: {
          'Authorization': "token #{access_token}"
      }
    )

    response = conn.get('/user')
    data = JSON.parse(response.body, symbolize_names: true)
    # require 'pry'; binding.pry
  end
end
