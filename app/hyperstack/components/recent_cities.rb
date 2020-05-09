class RecentCities < HyperComponent
  styles do
    {
      container: {
        fontSize: [WindowDims.height * WindowDims.width / 70_000, 17].max,
        overflow: :auto
      },
      header: {
        background: 'rgba(255, 255, 255, 0.6)',
        textAlign: :center,
        padding: [WindowDims.height * WindowDims.width / 80_000, 5].max, marginTop: 5, marginBottom: 20
      },
      paper: {
        background: 'rgba(255, 255, 255, 0.6)',
        padding: [WindowDims.height * WindowDims.width / 80_000, 5].max, marginTop: 5, marginBottom: 5
      },
      row: {
        display: :flex, flexFlow: :row, overflow: :hidden
      },
      metric: {
        fontSize: '0.6em',
        marginTop: '0.4em',
        width: '30%'
      },
      city: {
        flexGrow: 100
      },
      flag: {
        height: 20
      }
    }
  end

  def recent_cities
    cities = Prayer.last.recent_cities
    return @loaded_cities || {} if cities.loading?

    @loaded_cities = Prayer.recent_cities
  end

  after_mount do
    @last_rendered = Time.now
    every(15.seconds) do
      force_update! if @last_rendered < Time.now - 15.seconds
    end
  end

  after_update do
    @last_rendered = Time.now
  end

  render do
    Mui::Container(style(:container), class: 'row content') do
      Mui::Grid(:container, spacing: 1) do
        Mui::Grid(:item, xs: 12, sm: 8) do
          Mui::Paper(style(:header), elevation: 3) do
            'Recent Cities'
          end
          recent_cities.each do |city|
            Mui::Paper(style(:paper), elevation: 3, key: city.dup.delete(:created_at)) do
              DIV(style(:row)) do
                DIV(style(:metric)) { city[:created_at].distance_from_now_in_words }
                DIV(style(:city))   { "#{city[:city]}, #{city[:region]}" }
                IMG(style(:flag), src: city[:flag])
              end
            end
          end
        end
      end
    end
  end
end
