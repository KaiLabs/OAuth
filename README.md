## Starting to set up Google auth ##
1. go to: https://console.developers.google.com
2. create a new project
3. search contacts and enable contacts API
4. search google+ and enable google+ API
5. go to credentials
6. go to oauth consent screen and fill in the details
7. go to credentials screen and hit create credentials. Save your CLIENT ID and CLIENT SECRET. Will need these later.
8. choose web application and OAuth client ID. 
9. enter http://localhost:3000/auth/google_oauth2/callback for the authorized redirect URIs

1. Now, go to your ruby on rails application
2. In your gemfile, add *gem 'omniauth-google-oauth2', '~> 0.2.1'*.
3. run *bundle install*
4. create a new file in *config/initializers* called *omniauth.rb* with:
```ruby
OmniAuth.config.logger = Rails.logger
Rails.application.config.middleware.use OmniAuth::Builder do
	provider :google_oauth2, 
	'YOUR CLIENT ID', 
	'YOUR CLIENT SECRET', 
	{
		client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}},
		hd: 'wesleyan.edu',
  		skip_jwt: true	
	}
end
```
5. Now in the  *config/routes.rb* file, add the following lines of code to allow the google authentication routes to work with your project:
```ruby
	get 'auth/:provider/callback', to: 'sessions#create'
	get 'auth/failure', to: redirect('/')
	get 'signout', to: 'sessions#destroy', as: 'signout'

	resources :sessions, only: [:create, :destroy]
```
6. In your terminal, run the following commands to create the model to store user information:
```shell
	rails g model user provider uid name oauth_token oauth_expires_at:datetime
rake db:migrate
```
7.
