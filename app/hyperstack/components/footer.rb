class Footer < HyperComponent

  def link(path, text)
    return if path == App.location.pathname

    size = WindowDims.width > 1000 ? :large : :medium
    Mui::Grid(:item, xs: 4) do
      Mui::Button(:fullWidth, size: size, variant: :contained, color: :primary) { text }
      .on(:click) { mutate App.history.push(path) }
    end
  end

  render(DIV, style: { position: :fixed, bottom: 0, left: 0, marginBottom: 5, width: '100%' }) do
    Mui::Container() do
      Mui::Grid(:container, spacing: 1) do
        link('/home', 'Home')
        link('/about', 'About')
        link('/schedule', 'Schedule')
        link('/pray', 'Pray')
      end
    end
  end
end
