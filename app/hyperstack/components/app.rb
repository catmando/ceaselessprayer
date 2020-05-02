class App < HyperComponent
  include Hyperstack::Router

  class << self
    def reload!
      @reload = true
    end

    def reload?
      return unless @reload

      `window.newWorker.postMessage({ action: 'skipWaiting' })`
      @reload = false
      true
    end

    def install_prompter(prompter)
      @install_prompter = prompter
    end

    def ready_to_install?
      @install_prompter
    end

    def confirm_install!
      `#{@install_prompter}.prompt()`
      @install_prompter = nil
    end
  end

  after_render do
    `if (window.my_service_worker) window.my_service_worker.update()` # check for any updates
    nil
  end

  render do
    # dynamically set height so it works on mobile devices like iphone / safari
    # which does not use 100vh properly.
    DIV(class: :box, style: { height: WindowDims.height+1 }) do
      Header()
      Route('/about',    mounts: About)
      Route('/reload',   mounts: Reload)
      Route('/pray',     mounts: Pray)
      Route('/schedule', mounts: Schedule)
      Route('/home',     mounts: App.reload? ? Reload : Home)
      Route('/done',     mounts: Done)
      Route('/', exact: true) { mutate Redirect('/home') }
      Footer() unless App.location.pathname == '/'
    end
  end

  %x{
    window.newWorker = null;

      // The click event on the notification
      // document.getElementById('reload').addEventListener('click', function(){
      //   newWorker.postMessage({ action: 'skipWaiting' });
      // });

      if ('serviceWorker' in navigator) {
        // Register the service worker
        navigator.serviceWorker.register('/service-worker.js').then(reg => {
          console.log('got the worker')
          window.my_service_worker = reg
          reg.addEventListener('updatefound', () => {
            console.log('update found')
            // An updated service worker has appeared in reg.installing!
            window.newWorker = reg.installing;

            window.newWorker.addEventListener('statechange', () => {
              console.log('statechange');
              // Has service worker state changed?
              switch (window.newWorker.state) {
                case 'installed':
                  console.log('installed!');
    	            // There is a new service worker available, show the notification
                  if (navigator.serviceWorker.controller) {
                    console.log('its a controller')
                    // alert('will load new code')
                    #{reload!}
                    // window.newWorker.postMessage({ action: 'skipWaiting' });
                    // let notification = document.getElementById('notification');
                    // notification.className = 'show';
                  }

                  break;
              }
            });
          });
        }).catch(function(err) {
          // registration failed :(
            console.log('ServiceWorker registration failed: ', err);
          });;

        window.refreshing = null;
        // The event listener that is fired when the service worker updates
        // Here we reload the page

       navigator.serviceWorker.addEventListener('controllerchange', function () {
         if (refreshing) return;
         window.location.reload();
         refreshing = true;
       });

      }

    window.deferredPrompt = #{false};

    window.addEventListener('beforeinstallprompt', function(e) {
      // Prevent the mini-infobar from appearing on mobile
      e.preventDefault();
      // Stash the event so it can be triggered later.
      #{App.install_prompter(`e`)};
      // later deferredPrompt.prompt();
    })
  }

end
