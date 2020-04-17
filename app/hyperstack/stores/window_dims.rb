class WindowDims
  include Hyperstack::State::Observable
  class << self
    observer :width do
      window_size[0]
    end

    observer :height do
      window_size[1]
    end

    def grab_window_size
      mutate @window_size = `[jQuery(window).width(), jQuery(window).height()]`
    end

    def window_size
      @window_size ||= begin
        `jQuery(window).resize(function() {#{grab_window_size}})`
        grab_window_size
      end
    end
  end
end
