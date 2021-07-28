# rails-disk-project
Storage app on RoR and Vue + Vuetify

## Demo
Demo is available on heroku: https://potezny-dysk.herokuapp.com/

## Functionalities
+ Registering an account / Logging in
+ Uploading files
+ Removing files
+ Sharing files (download link)
+ Creating / removing / renaming directories
+ Admin interface

## Usage
Clone this repo, run: 
+ `npm install`
+ `bundle install`
+ `bundle exec rails webpacker:install`  
to install dependencies, and finally, run `rails s` and `ruby ./bin/webpack-dev-server` to launch both backend and frontend. You will be able to access the app at localhost:3000.
