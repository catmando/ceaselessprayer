class Home < HyperComponent

  styles do
    { button: { minHeight: 60, fontSize: 40 } } if WindowDims.area == :large
  end

  render do
    puts "footer height: #{Footer.height}, header height: #{Header.height} "
    if WindowDims.portrait?
      DIV(style: {display: :flex, flexFlow: :column, overflow: :hidden} ) do
        DIV(style: {paddingTop: Header.height + 10})
        Map()
        Overview()
      end
    else
      Mui::Container() do
        Mui::Grid(:container, spacing: WindowDims.width > 1200 ? 9 : 1) do
          Mui::Grid(xs: 12, style: { height: Header.height + 10 })
          Mui::Grid(:item, xs: 6) do
            DIV(style: {display: :flex, flexFlow: :column, overflow: :hidden, height: '100vh'} ) do
              Map()
              DIV(style: { paddingBottom: Footer.height + Header.height + 30 })
            end
          end
          Mui::Grid(:item, xs: 6) do
            Overview()
          end
        end
      end
    end
  end
end
