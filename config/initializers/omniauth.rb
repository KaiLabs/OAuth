OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '262701678261-gdtc3v25vjt01dfu860mdma4hj566sk4.apps.googleusercontent.com', 'ZCBU1nBy0mrEmsjG5rF8B--5', {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end