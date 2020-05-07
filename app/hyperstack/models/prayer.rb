class Prayer < ApplicationRecord

  unless RUBY_ENGINE == 'opal'
    IPSTACK_ACCESS_KEY = Rails.application.credentials.ipstack[:access_key]
  end

  before_create do
    existing = Prayer.find_by_ip(ip) || build_dummy_with_geo_data
    self.lat = existing[:lat]
    self.long = existing[:long]
    self.country = existing[:country]
    self.region_name = existing[:region_name]
    self.city = existing[:city]
    self.flag = existing[:flag]
  end

  def build_dummy_with_geo_data
    uri = URI("http://api.ipstack.com/#{ip}?access_key=#{IPSTACK_ACCESS_KEY}")
    json = JSON.parse(Net::HTTP.get(uri)).with_indifferent_access

    {
      lat: json[:latitude].round(5), long: json[:longitude].round(5),
      country: json[:country_name], region_name: json[:region_name],
      city: json[:city], flag: json[:location][:country_flag]
    }
  end

  scope :recent,
        -> { where('created_at > ?', Time.now - 1.day) },
        client: -> { created_at > Time.now - 1.day if created_at }
        # select: -> { select { |r| r.created_at && r.created_at > Time.now - 1.day} }

  def currency
    [(24.hours - (Time.now - created_at)) / 1.hour.to_f, 0].max rescue 24
  end

  def as_feature
    @as_feature ||= {
        type:       :Feature,
        properties: { currency: currency },
        geometry:   { type: :Point, coordinates: [ long, lat ] }
      }
  end

  def self.as_geojson
    {
      type: 'FeatureCollection',
      crs: { type: :name, properties: { name: 'ceaselessprayer-recent-prayers' } },
      features: Prayer.recent.collect(&:as_feature).tap { |p| puts "total prayers: #{p.count} "}
    }
  end
end
