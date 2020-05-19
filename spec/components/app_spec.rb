require 'spec_helper'

describe 'Top level App', js: true do
  before(:each) do
    10.times do
      Prayer.create(
        "ip" =>          "8.9.82.247",
        "lat" =>         0.4312965e2,
        "long" =>        -0.776038e2,
        "country" =>     "United States",
        "region_name" => "New York",
        "city" =>        "Rochester",
        "flag" =>        "http://assets.ipstack.com/flags/us.svg"
      )
    end

    mount 'App'
    on_client { @not_reset = true } # @not_reset will be reinitialized if we reload
  end

  it 'redirects to the home page on loading ' do
    expect { App.location.pathname }.on_client_to eq '/home'
  end

  ROUTES = {
    'pray' =>            'Pray',
    'home' =>            'Home',
    'about' =>           'About',
    'change-log' =>      'ChangeLog',
    'frequent-cities' => 'FrequentCities',
    'recent-cities' =>   'RecentCities'
  }

  ROUTES.each do |route, component|
    it "routes from '/#{route}' to the #{component} component" do
      on_client { App.history.push("/#{route}") }
      ROUTES.each_value do |c|
        expect { Object.const_get(c).mounted_components.count }
          .on_client_to eq(c == component ? 1 : 0)
      end
    end
  end

  it 'preloads the geojson data' do
    # if the data was not loaded the length would be 1
    wait_for_ajax # make sure all data has transferred
    expect { Prayer.as_geojson[:features].length }.on_client_to eq Prayer.count
  end

  it 'will reload the current page if the heart beat stops for 5 seconds' do
    on_client { App.history.push('/pray') }
    sleep 2.seconds
    expect { @not_reset }.on_client_to be_truthy
    # this works because the heartbeat is already initialized so is not
    # effected by Timecop travel
    Timecop.travel 5.seconds
    sleep 1.second
    expect { @not_reset }.on_client_to be_falsy
    expect(current_path).to eq('/pray')
  end

  context 'on an unrecoverable error' do
    before(:each) do
      client_option raise_on_js_errors: :off
      # move to a different page than home
      on_client { App.history.push('/pray') }
      # then remove the About component to cause problems
      on_client { Object.remove_const About }
    end

    it 'will reload the home page' do
      # try to load the bogus page
      on_client { App.history.push('/about') }
      sleep 2.seconds
      expect { @not_reset }.on_client_to be_falsy
      expect(current_path).to eq('/home')
    end

    it 'will display an error fallback while loading' do
      # in order to have time see the error message before reload we have
      # setup a onbeforeunload handler and cancel it
      evaluate_script "window.onbeforeunload = function() { return 'hang on!'; }"
      # weirdly we have to focus on the window before it will update onbeforeunload!!
      page.find('#app_bar').click
      # now move to the bogus page
      on_client { App.history.push('/about') }
      # page should be attempted to reload but we will cancel it
      page.driver.browser.switch_to.alert.dismiss
      # so we can see if we are displaying a dialog
      expect(page).to have_selector('#tp_display_error')
    end
  end

  context 'PWA.check_for_updates!' do
    before(:each) do
      mount 'App' do
        # make sure Timecop is initialized on the client so the intervals
        # can be controlled by Timecop
        Timecop.init
        # stub the check_for_updates! so we can capture how many times its called
        PWA.class_eval do
          class << self
            attr_reader :check_for_updates_count
            def check_for_updates!
              @check_for_updates_count ||= 0
              @check_for_updates_count += 1
            end
          end
        end
      end
    end

    it 'should be called immediately after booting' do
      expect { PWA.check_for_updates_count }.on_client_to eq(1)
    end

    it 'should be called every 10 minutes' do
      Timecop.travel 10.minutes
      expect { PWA.check_for_updates_count }.on_client_to eq(2)
    end
  end
end
