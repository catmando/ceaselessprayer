class Header < HyperComponent
  render(DIV, style: {flexGrow: 1}) do
    Mui::AppBar(position: :fixed, id: 'header', size: :large) do
      Mui::Toolbar() do
        puts "window width: #{WindowDims.width} height: #{WindowDims.height}"
        'Join us in world wide prayer for healing'
      end
    end
  end
end
