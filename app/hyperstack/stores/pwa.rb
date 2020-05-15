class PWA
  # Handles installation as a Progressive Web app

  # The sequence is:

  #   on boot setup a listener for 'beforeinstallprompt'
  #     this event will be triggered by the OS once the OS determines the app
  #     is suitable to install, and the user appears to be using the app.  Once
  #     the app is installed, this will not be triggered.

  #     the value sent to the event is an 'install prompter' object.  The
  #     app is responsible for calling the prompt method on this object, when the
  #     user/app is ready to install.  This will bring up an OS level prompt
  #     confirming that the user wants to install.

  #   the App checks ready_to_install? which will return a truthy value if
  #   if beforeinstallprompt has been called, and we have an install_prompter
  #   object.  If ready_to_install? is true then the app displays a button or other
  #   way for the user to indicate they wish to install (or can just go ahead and
  #   begin the install)

  #   when the user indicates they want to install confirm_install! is called which
  #   calls the saved prompt() javascript method.

  #   Once an app is installed it will need to be updated when code changes.
  #   The app can call check_for_updates! which will update the code if its changed.

  #   However after updating the code, the app controls when we start running the
  #   new code by calling the update! method.

  class << self
    def ready_to_install?
      # @install_prompter is set by the webworker code (see below)
      @install_prompter
    end

    def confirm_install!
      return unless @install_prompter

      `#{@install_prompter}.prompt()`
      @install_prompter = nil
    end

    def ready_to_update?
      @ready_to_update
    end

    def update!
      puts 'update!'
      # see app/views/service_worker/service_worker.js.erb
      # for the skipWaiting handler
      `window.newWorker.postMessage({ action: 'skipWaiting' })`
      nil
    end

    def check_for_updates!
      return if @ready_to_update || !Hyperstack.env.production?
      # in order to test in the debugger type
      # Opal.Hyperstack.$env().literal = 'production' into the JS console
      # after the app is loaded.

      puts 'check_for_updates!'
      `if (window.my_service_worker) window.my_service_worker.update()`
      nil
    end

    # private methods
    def ready_to_update!
      puts 'ready_to_update!'
      @ready_to_update = true
    end

    def set_install_prompter(prompter)
      @install_prompter = prompter
    end
  end

  %x{
    window.newWorker = null;

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
                  console.log('we have a new controller')
                  #{ready_to_update!}
                }
                break;
            }
          });
        });
      }).catch(function(err) {
        // registration failed :(
        console.log('ServiceWorker registration failed: ', err);
      });

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
      #{PWA.set_install_prompter(`e`)};
    })
  }

end
