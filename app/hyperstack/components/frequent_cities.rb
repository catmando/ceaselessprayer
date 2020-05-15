class FrequentCities < HyperComponent
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
      count: {
        width: '20%'
      },
      city: {
        flexGrow: 100
      },
      flag: {
        height: 20
      }
    }
  end

  render do
    Mui::Container(styles(:container), class: 'row content') do
      Mui::Grid(:container, spacing: 1) do
        Mui::Grid(:item, xs: 12, sm: 8) do
          Mui::Paper(styles(:header), elevation: 3) do
            'Top cities in the last 48 hours'
          end

          OL(style: { listStyleType: :none, paddingLeft: 0 }) do
            Prayer.frequent_cities(2.days).each do |city|
              LI(key: city.merge(count: 0, flag: nil)) do
                Mui::Paper(styles(:paper), elevation: 3) do
                  DIV(styles(:row)) do
                    DIV(styles(:count)) { city[:count].to_s }
                    DIV(styles(:city))  { "#{city[:city]}, #{city[:region]}" }
                    IMG(styles(:flag),  src: city[:flag])
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
