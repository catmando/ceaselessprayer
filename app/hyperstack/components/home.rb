class Home < HyperComponent
  render(DIV, style: { marginTop: 75 }) do
    Map()
    Overview()
  end
end
