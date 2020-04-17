class Geolocation
  # include Hyperstack::State::Observable

  URL = 'http://api.ipstack.com/8.9.82.247?access_key=1cd008d802d88efd404becd4d7cd96fd'

  def self.locate
    @location ||= HTTP.get(URL).then { |resp| resp.json }
  end
end
