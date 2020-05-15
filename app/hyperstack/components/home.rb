class Home < HyperComponent
  def p?(yes, no)
    WindowDims.portrait? ? yes : no
  end

  styles do
    map_size = WindowDims.area == :small ? 50 : 60
    {
      container:
        { display: :flex, flexFlow: p?(:column, :row), overflow: :hidden },
      map:
        p?({ margin: 5 }, flex: 1, flexGrow: map_size, margin: 5),
      overview:
        p?({ flex: 1, margin: 5 }, flex: 2, flexGrow: 100 - map_size, margin: 5)
    }
  end

  render do
    DIV(class: 'row content') do
      DIV(styles(:container)) do
        Map(styles(:map))
        Overview(styles(:overview))
      end
    end
  end
end
