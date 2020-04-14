class App < HyperComponent
  include Hyperstack::Router

  render do
    DIV(style: { flexDirection: :column, height: '100vh' }) do
      Header()
      Route('/about',    mounts: About)
      Route('/pray',     mounts: Pray)
      Route('/schedule', mounts: Schedule)
      Route('/home',     mounts: Home)
      Route('/', exact: true) { mutate Redirect('/home') }
      Footer() unless App.location.pathname == '/'
    end
  end
end
