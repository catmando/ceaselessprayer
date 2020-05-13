class Map < HyperComponent
  def height
    jQ['#map'].height
  end

  def geojson_slice
    geojson = Prayer.as_geojson
    geojson.merge(features: geojson[:features][0..-@geojson_pos]).to_n
  end

  def update_map
    puts "updating map"
    `#{map}.getSource('recent-prayers').setData(#{geojson_slice})`
    mutate @geojson_pos = [@geojson_pos - 5, 1].max if @geojson_pos > 1
  rescue Exception
    nil
  end

  def initial_data
    {
      type: 'FeatureCollection',
      crs: { type: :name, properties: { name: 'ceaselessprayer-recent-prayers' } },
      features: []
    }
  end

  def map
    return @map if @map

    puts 'initializing map'
    map = nil
    %x{
      mapboxgl.accessToken = 'pk.eyJ1IjoiY2F0bWFuZG8iLCJhIjoiY2s4emZ2MnVjMXNiMjNnanNicGFpaWVvNiJ9.OqPP4lJF1sUJlRynB2RSaw';
      map = new mapboxgl.Map({
        container: 'map',
        // style: 'mapbox://styles/mapbox/dark-v8',
        style: 'mapbox://styles/catmando/ck9u5nvcy17321ip3gzhoud7i',
        // center: #{[-50, 20]},
        // zoom: #{zoom},
        bounds: [-150, 70, 30, -55],
        // bounds: [-30, 30, -30, -30] // test fixed map size
        interactive: false
        });

      map.on('load', function() {
        // map.fitBounds([-150, 70, 30, -55])
        // Add a geojson point source.
        map.addSource('recent-prayers', {
        'type': 'geojson',
        'data': #{initial_data.to_n}
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
              'rgba(246,191,167,0)',
              0.1,
              'rgb(249,128,7)',
              0.2,
              'rgb(246,246,175)',
              0.4,
              'rgb(252,252,74)',
              0.6,
              'rgb(209,243,250)',
              1,
              'rgb(255,255,255)'
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
        #{pan; every(8) { pan }}
        #{puts 'loaded map!'}
        #{mutate};
      });
    }
    @map = map
  end

  def pan
    `#{map}.panBy([100, 0], {duration: 8000, easing: function(x) { return x }})`
  end

  after_render :update_map

  before_mount do
    Hyperstack::Model.load do
      puts "loading"
      Prayer.as_geojson[:features].length
    end.then do |geojson_pos|
      puts "geojson pos = #{geojson_pos}"
      mutate @geojson_pos = geojson_pos
    end
  end

  render do
    puts "------rendering pos = #{@geojson_pos}"

    WindowDims.portrait? # to force update of map when orientation changes
    DIV(style: ics.merge(height: '100%', opacity: 0.6)) do
      if @geojson_pos
        DIV(id: :map, style: { width: '100%', overflow: :hidden, height: '100%'} )
      else
        Mui::CircularProgress(size: 150, style: {margin: 20}, color: :secondary)
      end
    end
  end
end
