class Footer < HyperComponent

  def self.push_path(path)
    mutate App.history.push(path)
  end

  def link(path, text)
    return if path == App.location.pathname

    size = WindowDims.width > 1000 ? :large : :medium
    Mui::Grid(xs: 0, lg: 3)
    Mui::Grid(:item, xs: 12, lg: 6) do
      Mui::Button(:fullWidth, size: size, variant: :contained, color: :primary) { text }
      .on(:click) { Footer.push_path(path) }
    end
    Mui::Grid(xs: 0, lg: 3)
  end

  render(DIV, style: { position: :fixed, bottom: 0, left: 0, marginBottom: 5, width: '100%' }) do
    Mui::Container() do
      Mui::Grid(:container, spacing: 1) do
        if App.location.pathname == '/pray'
          link('/done', 'Done')
        elsif App.location.pathname == '/done'
          link('/home', 'Close')
        else
          link('/pray', 'Pray Now!')
        end
        # link('/home', 'Home')
        # link('/about', 'About')
        # link('/schedule', 'Schedule')
        # link('/pray', 'Pray')
      end
    end
  end
end
