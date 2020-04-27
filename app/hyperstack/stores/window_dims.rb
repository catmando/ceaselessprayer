class WindowDims
  include Hyperstack::State::Observable
  class << self
    observer :width do
      window_size[0]
    end

    observer :height do
      window_size[1]
    end

    observer :portrait? do
      height > width
    end

    observer :landscape? do
      !portrait?
    end

    observer :area do
      if height * width > 1_000_000
        :large
      elsif height * width > 400 * 700
        :medium
      else
        :small
      end
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
