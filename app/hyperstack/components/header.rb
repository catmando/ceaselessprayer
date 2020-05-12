class Header < HyperComponent

  def self.open_menu!
    mutate @menu_up = true
  end

  def self.close_menu!
    mutate @menu_up = false
  end

  def self.menu_open?
    observe !!@menu_up
  end

  def self.menu_anchor
    `#{jQ['#nav_menu']}[0]`
  end

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
      hero: { width: '100%', fontSize: font_size },
      menu_item: { fontSize: font_size / 2 }
    }
  end

  def menu_link(path, text)
    return if path == App.location.pathname

    Mui::MenuItem(style(:menu_item)) { text }
    .on(:click) do
      Footer.push_path(path)
      Header.close_menu!
    end
  end

  def install_link
    return unless App.ready_to_install?

    Mui::MenuItem(style(:menu_item)) { 'Add to Home Screen' }
    .on(:click) do
      App.confirm_install!
      Footer.push_path('/home')
      Header.close_menu!
    end
  end


  render(DIV, id: :app_bar, class: 'row header', style: {zIndex: 99, marginBottom: 5}) do
    Mui::AppBar(style(:app_bar), position: :relative, id: 'header') do
      Mui::Toolbar(style(:tool_bar)) do
        Mui::IconButton(edge: :start, color: :inherit, aria: {label: :menu, controls: :menu, haspopup: true}) do
          Icon::Menu(style(:menu_icon), id: :nav_menu)
        end.on(:click) { Header.open_menu! }
        Mui::Typography(style(:hero)) { 'Join us in world wide prayer for healing' }
      end
    end
    Mui::Menu(:keepMounted, id: :menu, anchorEl: Header.menu_anchor, open: Header.menu_open?) do
      menu_link('/home', 'Home')
      menu_link('/pray', 'Prayers')
      menu_link('/about', 'About')
      menu_link('/frequent-cities', 'Frequent Cities')
      menu_link('/recent-cities', 'Recent Cities')
      install_link
      menu_link('/change-log', 'Change Log')
    end.on(:close) { Header.close_menu! } if Header.menu_open?
  end
end
