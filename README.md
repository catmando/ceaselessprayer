# README

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

