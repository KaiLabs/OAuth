OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, 

  # YOUR CLIENT ID
  '636361556889-1hub2nps8t11tjnju51qc4fif0f14a2k.apps.googleusercontent.com', 
  
  # YOUR CLIENT SECRET
  'Ldojff143lIHSMZegPDDkX5C', 
  {
  	client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}, 

  	# RESTRICTS TO WESLEYAN PEOPLE
  	hd: 'wesleyan.edu', 

  	skip_jwt: true
  }
end