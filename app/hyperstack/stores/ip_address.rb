class IpAddress
  def self.then(&block)
    @address ||= HTTP.get('https://api.ipify.org?format=json').then do |resp|
      resp.json[:ip]
    end
    @address.then(&block)
  end
end
