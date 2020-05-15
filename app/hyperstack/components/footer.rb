class Footer < HyperComponent
  # The footer has four states:
  # in most pages it has a button to bring you to the prayer page
  # on the prayer page you have a done button instead
  # on the done page (after praying) there is a final done button
  # when this button is clicked the main menu is popped up and the button is hidden

  styles do
    # override default button style if we have enough space
    { button:    { minHeight: 60, fontSize: 40 } } if WindowDims.area == :large
    { container: { marginTop: 5, marginBottom: 5, width: '100%' } }
  end

  def size
    WindowDims.width > 1000 ? :large : :medium
  end

  def button(text, &block)
    Mui::Grid(xs: 0, lg: 3)
    Mui::Grid(:item, xs: 12, lg: 6) do
      Mui::Button(:fullWidth, styles(:button), size: size, variant: :contained, color: :primary) do
        text
      end.on(:click, &block)
    end
    Mui::Grid(xs: 0, lg: 3)
  end

  def self.push_path(path)
    mutate App.history.push(path)
  end

  render do
    Mui::Container(styles(:container), class: 'row footer') do
      Mui::Grid(:container, spacing: 1) do
        if App.location.pathname == '/pray'
          # only on the pray page
          button('Done')      { Footer.push_path('/done') }
        elsif App.location.pathname != '/done'
          # on any other page but Done
          button('Pray Now!') { Footer.push_path('/pray') }
        elsif !Header.menu_open?
          # clicking done will open the menu, which will hide the done button
          button('Done')      { Header.open_menu! }
        end
      end
    end
  end
end
