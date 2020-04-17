class Map < HyperComponent
  def zoom
    [(WindowDims.height - 568) * (1.9 / (1421 - 568)), 0].max
  end

  def height
    [250 + (WindowDims.height - 568) * (750 / (1421 - 568)), 150].max
  end

  def update_map
    # return unless @map || `#{@map}.getSource('recent-prayers') != undefined`
    `#{@map}.getSource('recent-prayers').setData(#{@geojson.to_n})`
  rescue Exception => e
    nil
  end

  def draw_map
    return if @map

    map = nil
    %x{
      mapboxgl.accessToken = 'pk.eyJ1IjoiY2F0bWFuZG8iLCJhIjoiY2s4emZ2MnVjMXNiMjNnanNicGFpaWVvNiJ9.OqPP4lJF1sUJlRynB2RSaw';
      map = new mapboxgl.Map({
        container: 'map',
        style: 'mapbox://styles/mapbox/dark-v10',
        center: #{[0, 10]},
        zoom: #{zoom}
        });

      map.on('load', function() {
        // Add a geojson point source.
        map.addSource('recent-prayers', {
        'type': 'geojson',
        'data': #{@geojson.to_n}
        });

        map.addLayer({
          'id': 'prayers-heat',
          'type': 'heatmap',
          'source': 'recent-prayers',
          'maxzoom': 0,
          'paint': {
            // Increase the heatmap weight based on frequency and property currency
            'heatmap-weight': [
              'interpolate',
              ['linear'],
              ['get', 'currency'],
              0,  0,
              24, 1
            ],

            // Color ramp for heatmap.  Domain is 0 (low) to 1 (high).
            // Begin color ramp at 0-stop with a 0-transparancy color
            // to create a blur-like effect.
            'heatmap-color': [
              'interpolate',
              ['linear'],
              ['heatmap-density'],
              0,
              'rgba(33,102,172,0)',
              0.2,
              'rgb(103,169,207)',
              0.4,
              'rgb(209,229,240)',
              0.6,
              'rgb(253,219,199)',
              0.8,
              'rgb(239,138,98)',
              1,
              'rgb(178,24,43)'
            ],

            // Adjust the heatmap radius by currency
            'heatmap-radius': [
              'interpolate',
              ['linear'],
              ['get', 'currency'],
              0,  0,
              24, 15
            ]
          }
        },
        'waterway-label'
        );
      })
    }
    @map = map
    pan
    every(10) { pan }
  end

  def pan
    `#{@map}.panBy([100, 0], {duration: 10000, easing: function(x) { return x }})`
  end

  after_mount  :draw_map
  after_update :update_map

  render do
    @geojson = Prayer.as_geojson
    DIV(style: { position: :relative, marginTop: 5, width: '100%', height: height}) do
      DIV(id: :map, style: { position: :absolute, top: 0, bottom: 0, width: '100%'})
    end
  end
end
