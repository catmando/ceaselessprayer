class App < HyperComponent
  include Hyperstack::Router

  # Heartbeat.  Detect if device has gone to sleep
  # But load the main data first, otherwise it may take
  # so long on the first request that we will timeout
  # and reload the page

  before_mount do
    Hyperstack::Model.load do
      Prayer.as_geojson
    end.then do
      time = Time.now
      every(0.25) { time = check_wakeup(time) }
    end
  end

  def check_wakeup(time)
    unless (Time.now - time).between?(0, 3) || @waking_up
      puts "*********************** RELOADING AFTER SLEEP ****************************"
      `window.location.reload()`
      @waking_up = true
    end
    Time.now
  end

  # error fall back display while we are waiting for page reload.  See rescues block below
  def display_error
    Mui::Paper(id: :tp_display_error, elevation: 3, style: { margin: 30, padding: 10, fontSize: 30, color: :red }) do
      'Something went wrong, we will be back shortly!'
    end
  end

  render do
    return display_error if @display_error

    # dynamically set height so it works on mobile devices like iphone / safari
    # which does not use 100vh properly.

    DIV(class: :box, style: { height: WindowDims.height+1 }) do
      Header()
      Switch() do
        Route('/about',           mounts: About)
        Route('/reload',          mounts: Reloading)
        Route('/pray',            mounts: Pray)
        Route('/home',            mounts: PWA.ready_to_update? ? Reloading : Home)
        Route('/change-log',      mounts: ChangeLog)
        Route('/frequent-cities', mounts: FrequentCities)
        Route('/recent-cities',   mounts: RecentCities)
        Route('/done',            mounts: Done)
        Route('*')                { mutate Redirect('/home') }
      end
      Footer() unless App.location.pathname == '/'
    end
  end

  rescues do |error, info|
    return if Hyperstack.env.development?

    # send the error to the server log, and then reload the page
    ReportError.run(message: error.message, backtrace: error.backtrace, info: info)
    `window.location.href = '/home'`
    # react needs to see some state change so it knows we won't keep in an endless loop
    mutate @display_error = true
  end

  # check for any pwa updates on boot and every 10 minutes after
  after_mount do
    PWA.check_for_updates!
    every(10.minutes) { PWA.check_for_updates! }
  end
end
