# README

Sorry for the lack of any decent readme.

This app is built on [hyperstack](https://hyperstack.org) plus MaterialUI components.

The app using ipstack to convert ip addresses into geo location information.  So you will need to get your own ipstack account (free) here: https://ipstack.com/

Edit credentials.yml.enc or set the `IPSTACK_ACCESS_KEY` environment variable when running the app.

You should be able to 
+ clone, 
+ bundle install, 
+ bundle exec rails db:setup
+ run `bundle exec foreman start`
+ Visit localhost:5000

In development mode hyperstack has an integrated hotloader, so any changes will be reflected on screen as you edit.

Let me know if you have any issues.

TBD: 

Test Specs
Better Install Instructions

Translations

Contributors are very welcome.  The UX, styling, etc probably could use help.

