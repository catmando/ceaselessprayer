class Prayer < ApplicationRecord
  scope :recent, ->(_ts = nil) { where('created_at > ?', Time.now - 1.day)}

  def currency
    [(24.hours - (Time.now - created_at)) / 1.hour.to_f, 0].max rescue 24
  end

  def as_feature
    {
      type:       :Feature,
      properties: { currency: currency },
      geometry:   { type: :Point, coordinates: [ long, lat ] }
    }
  end

  def self.as_geojson(ts)
    {
      type: 'FeatureCollection',
      crs: { type: :name, properties: { name: 'ceaselessprayer-recent-prayers' } },
      features: Prayer.recent(ts.to_s).collect(&:as_feature).tap { |x| puts x }
    }
  end
end
