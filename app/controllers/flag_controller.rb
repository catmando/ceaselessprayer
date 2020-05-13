require 'net/http'

class FlagController < ActionController::Base
  def get
    url = URI.parse("http://assets.ipstack.com/flags/#{request.url.split('/').last}")
    image = Net::HTTP.get_response(url)
    expires_in 1.day, public: true
    send_data image.body, type: image.content_type, disposition: 'inline'
  end
end
