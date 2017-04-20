OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, 

  # YOUR CLIENT ID
  '262701678261-gdtc3v25vjt01dfu860mdma4hj566sk4.apps.googleusercontent.com', 
  
  # YOUR CLIENT SECRET
  'ZCBU1nBy0mrEmsjG5rF8B--5', 
  {
  	client_options: {ssl: {ca_file: '/usr/lib/ssl/certs/ca-certificates.crt'}}, 

  	# RESTRICTS TO WESLEYAN PEOPLE
  	hd: 'wesleyan.edu', 

  	skip_jwt: true
  }
end