class Footer < HyperComponent

  def self.push_path(path)
    if path == '/next'
      Header.open_menu!
    else
      mutate App.history.push(path)
    end
  end

  styles do
    { button: { minHeight: 60, fontSize: 40 } } if WindowDims.area == :large
  end

  def self.height
    WindowDims.area == :large ? 100 : 60
  end

  def size
    WindowDims.width > 1000 ? :large : :medium
  end

  def link(path, text, install_option = nil)
    return if path == App.location.pathname
    return done_with_install if install_option && App.ready_to_install?

    Mui::Grid(xs: 0, lg: 3)
    Mui::Grid(:item, xs: 12, lg: 6) do
      Mui::Button(:fullWidth, style(:button), size: size, variant: :contained, color: :primary) { text }
      .on(:click) { Footer.push_path(path) }
    end
    Mui::Grid(xs: 0, lg: 3)
  end

  def done_with_install
    Mui::Grid(xs: 0, lg: 3)
    Mui::Grid(:item, xs: 6, lg: 3) do
      Mui::Button(:fullWidth, style(:button), size: size, variant: :contained, style: {backgroundColor: '#4caf50'}) { 'Bookmark' }
      .on(:click) { mutate App.confirm_install! }
    end
    Mui::Grid(:item, xs: 6, lg: 3) do
      Mui::Button(:fullWidth, style(:button), size: size, variant: :contained, style: {backgroundColor: '#ff9800'}) { 'Done' }
      .on(:click) { Footer.push_path('/home') }
    end
    Mui::Grid(xs: 0, lg: 3)
  end

  render(DIV, class: 'row footer', id: :action_button, style: { marginTop: 5, marginBottom: 5, width: '100%' }) do
    Mui::Container() do
      Mui::Grid(:container, spacing: 1) do
        if App.location.pathname == '/pray'
          link('/done', 'Done')
        elsif App.location.pathname == '/done'
          link('/next', 'Done', true) unless Header.menu_open?
        else
          link('/pray', 'Pray Now!')
        end
      end
    end
  end
end
