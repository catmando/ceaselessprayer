class Geolocation
  # include Hyperstack::State::Observable

  ACCESS_KEY = '1cd008d802d88efd404becd4d7cd96fd'

  def self.locate
    @location ||= begin
      HTTP.get("https://api.ipify.org?format=json").then do |resp|
        HTTP.get("http://api.ipstack.com/#{resp.json[:ip]}?access_key=#{ACCESS_KEY}").then do |resp|
          resp.json
        end
      end
    end
  end
end
