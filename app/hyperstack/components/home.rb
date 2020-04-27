class Home < HyperComponent

  def size
    WindowDims.portrait? ? {xs: 12} : {xs: 6}
  end

  render(DIV ) do
    Mui::Container() do
      Mui::Grid(:container, spacing: WindowDims.width > 1200 ? 9 : 1) do
        Mui::Grid(xs: 12, style: { height: Header.height + 10 })
        Mui::Grid(:item, size) do
          Map()
        end
        Mui::Grid(:item, size) do
          Overview()
        end
      end
    end
  end
end
