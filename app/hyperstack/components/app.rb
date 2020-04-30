class App < HyperComponent
  include Hyperstack::Router

  # after_mount do
  #   after(10) { `window.scrollTo(0, 1)` }
  # end

  render do
    # dynamically set height so it works on mobile devices like iphone / safari
    # which does not use 100vh properly.
    DIV(class: :box, style: { height: WindowDims.height+1 }) do
      Header()
      Route('/about',    mounts: About)
      Route('/pray',     mounts: Pray)
      Route('/schedule', mounts: Schedule)
      Route('/home',     mounts: Home)
      Route('/done',     mounts: Done)
      Route('/', exact: true) { mutate Redirect('/home') }
      Footer() unless App.location.pathname == '/'
    end
  end
end
