class Prayer < ApplicationRecord
  # Prayers are simple records with a create time, ip address, and geo location data
  # At some point this should be refactored so that there is an ip address table
  # and all that is stored in the Prayer is the time stamp and link to the ip address table.
  # Currently we duplicate the geo location with each prayer

  unless RUBY_ENGINE == 'opal'
    IPSTACK_ACCESS_KEY = ENV['IPSTACK_ACCESS_KEY'] || Rails.application.credentials.ipstack[:access_key]
  end

  before_create do
    # this is a poor man's join table.

    # skip if everything is defined (i.e. during seeding / testing)
    next if lat && long && country && region_name && city && flag

    # find an existing record with this IP address otherwise
    # fetch from ipstack.com and fill in the geo data
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
        # the client option is a hyperstack extension it allows us to
        # update the scope on the client without talking to the server
        # if the client proc returns true then the record is included
        # in the scope
        client: -> { created_at > Time.now - 1.day if created_at }

  def self.group_by_city
    group('city')
      .group('region_name')
      .group('country')
      .group('flag')
  end

  def flag_proxy(flag)
    "/flag/#{flag.split('/').last}"
  end

  def self.frequent_cities(since)
    cities = last&.frequent_cities(since) || []
    return @frequent_cities || {} if cities.try(:loading?)

    @frequent_cities = cities.sort { |c1, c2| c2[:count] <=> c1[:count] }
  end

  server_method(:frequent_cities, default: {}) do |since|
    Prayer.where('created_at > ?', Time.now - since)
          .group_by_city
          .count
          .collect do |city, count|
            { city: city[0], region: city[1], country: city[2], flag: flag_proxy(city[3]), count: count }
          end
  end

  def self.recent_cities
    cities = last&.recent_cities || []
    return @recent_cities || {} if cities.try(:loading?)

    @recent_cities =
      cities.each { |c| c[:created_at] = Time.parse(c[:created_at]) }
            .sort { |c1, c2| c2[:created_at] <=> c1[:created_at] }
  end

  server_method(:recent_cities, default: {}) do
    Prayer.group_by_city
          .maximum(:created_at)
          .collect do |city, created_at|
            { city: city[0], region: city[1], country: city[2], flag: flag_proxy(city[3]), created_at: created_at }
          end
  end

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
    # returns a hash as expected by MapBox
    {
      type:     'FeatureCollection',
      crs:      { type: :name, properties: { name: 'ceaselessprayer-recent-prayers' } },
      features: Prayer.recent.collect(&:as_feature)
    }
  end
end
