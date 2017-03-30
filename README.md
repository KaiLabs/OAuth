## Starting to set up Google auth ##
1. go to: https://console.developers.google.com
2. create a new project
3. search contacts and enable contacts API
4. search google+ and enable google+ API
5. go to credentials
6. go to oauth consent screen and fill in the details
7. go to credentials screen and hit create credentials
8. choose web application and OAuth client ID. 
9. enter http://localhost:3000/auth/google_oauth2/callback for the authorized redirect URIs
client ID: 262701678261-gdtc3v25vjt01dfu860mdma4hj566sk4.apps.googleusercontent.com
client secret: ZCBU1nBy0mrEmsjG5rF8B--5


1. start rails app
2. add gem "omniauth-google-oauth2", "~> 0.2.1" to gemfile
3. run bundle install
4. create a new file in config/initializers called omniauth.rb with:

OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '262701678261-gdtc3v25vjt01dfu860mdma4hj566sk4.apps.googleusercontent.com', 'ZCBU1nBy0mrEmsjG5rF8B--5', {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end

5.
