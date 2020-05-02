class Header < HyperComponent

  def self.height
    [160, [56, WindowDims.width / 1900 * 170].max].min
  end

  styles do
    next unless WindowDims.width > 700 && WindowDims.height > 700

    font_size = [100, Header.height * 0.5].min
    {
      app_bar: { minHeight: Header.height, paddingTop: 20, paddingBottom: 20, paddingRight: 60 },
      tool_bar: { width: '100%', textAlign: :center, fontSize: font_size},
      menu_icon: { fontSize: font_size },
      hero: { width: '100%' },
      menu_item: { fontSize: font_size / 2 }
    }
  end

  def menu_link(path, text)
    return if path == App.location.pathname

    Mui::MenuItem(style(:menu_item)) { text }
    .on(:click) do
      Footer.push_path(path)
      mutate @anchor = nil
    end
  end

  render(DIV, id: :app_bar, class: 'row header', style: {zIndex: 99, marginBottom: 5}) do
    Mui::AppBar(style(:app_bar), position: :relative, id: 'header') do
      Mui::Toolbar(style(:tool_bar)) do
        Mui::IconButton(edge: :start, color: :inherit, aria: {label: :menu, controls: :menu, haspopup: true}) do
          Icon::Menu(style(:menu_icon))
        end.on(:click) { |e| mutate @anchor = e.target }
        DIV(style(:hero)) { 'Join us in world wide prayer for healing' }
      end
    end
    Mui::Menu(:keepMounted, id: :menu, anchorEl: @anchor.to_n, open: !!@anchor) do
      menu_link('/home', 'Home')
      menu_link('/about', 'About')
    end.on(:close) { mutate @anchor = nil } if @anchor
  end
end
