class Map < HyperComponent
  def zoom
    [(height - 337) * (0.7 / (765 - 337)) + 0.3, 0].max
  end

  def height
    if WindowDims.portrait?
      (WindowDims.height-(jQ['#overview'].height || 150)-(jQ['#action_button'].height || 150)-Header.height-70)
    else
      (WindowDims.height-(jQ['#action_button'].height || 150)-Header.height-50)
    end
  end

  def update_map
    draw_map(force: true) && return if @height != height

    `#{@map}.getSource('recent-prayers').setData(#{@geojson.to_n})`
  rescue Exception => e
    nil
  end

  def draw_map(force: false)
    return if @map && !force

    @height = height
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
      })
    }
    @map = map
    pan
    every(10) { pan }
  end

  def pan
    `#{@map}.panBy([100, 0], {duration: 10000, easing: function(x) { return x }})`
  end

  before_mount { @time_stamp = Time.now }
  after_mount  :draw_map
  after_update :update_map

  render do
    puts "rendering map"
    WindowDims.portrait? # to force update of map when orientation changes
    @geojson = Prayer.as_geojson(@time_stamp)
    DIV(style: { position: :relative, marginTop: 5, width: '100%', height: height}) do
      DIV(id: :map, style: { position: :absolute, top: 0, bottom: 0, width: '100%'})
    end
  end
end
