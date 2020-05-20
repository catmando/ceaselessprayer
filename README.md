# CeaselessPrayer

See [CeaselessPrayer.org](https://ceaselessprayer.org) for more info.

This app is built on [hyperstack](https://hyperstack.org) plus MaterialUI components.

### Setting up for development

You should be able to 

+ clone, 
+ bundle install, 
+ get an ipstack key (important see below)
+ bundle exec rails db:setup
+ run `bundle exec foreman start`
+ Visit localhost:5000
+ `bundle exec rake` to run the specs

> Note: The app uses ipstack to convert ip addresses into geo location information.  So you will need to get your own ipstack account (free) here: https://ipstack.com/  
> Edit credentials.yml.enc or set the `IPSTACK_ACCESS_KEY` environment variable to your key when running the app.

In development mode hyperstack has an integrated hotloader, so any changes will be reflected on screen as you edit.

### Help Needed

Contributors are very welcome.  The UX, styling, etc probably could use help.

Setting up a CI would be great as well.  

Anything else you see we are welcome to new ideas.

Translations would also be a big help.  If you are not a developer but would still like to contribute translations, let us know 

### Comparison Shopping 

This is a relatively small App.  If you would like to use it to demo your favorite framework, feel free to fork a branch and show us what your framework can do!

### App Structure Overview

Hyperstack is a extension of Rails that lets you create React code in Ruby.  Hyperstack components replace your views, and run on the client.  Rails models are automatically synced between the components and the server.

Hyperstack code can be found in the app/hyperstack directory.  The main subdirectories are:

+ components - where the UI components are stored
+ models - where any rails models that are shared are stored.
+ stores - these are for keeping local data storage not related to models.
+ operations - these are TrailBlazer style service objects, that also run on client and server.

The rails routes file routes all traffic to the App component (in hyperstack/components/app.rb)  This is a "Single Page App" so all changes in the URL are handled without reloading the page via routing information in the App component.

Based on which view the user is looking at - home, about, pray, frequent-cities, recent-cities, change-log - the top level App will "mount" the corresponding component between the Header, and Footer components.

Inside of each component there is always a render block which is what will generate the react components (and resulting HTML) for that component.  Components are re-rerendered automatically as needed when the state of data changes.   Any change to Models or scopes for example will trigger a rerender of components displaying that data.

Hyperstack Models are compatible with ActiveRecord models and will execute the same on client or server.  Hyperstack adds some extensions in places where its useful to break this abstraction.   This app uses two of those extensions:

+ The `server_method` macro which creates an instance method that will always run on the server.  Typically this is done for perforamance reasons.  Our our case we want to aggregate data on the server rather than ship the all the data to the client and aggregate it there.
+ The `client` option on scopes scope updates to be computed on the client which helps both the client and server performance.
