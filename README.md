## Setting up Google API ##
1. Go to: https://console.developers.google.com
2. Create a new project
3. Search contacts and enable contacts API
4. Search google+ and enable google+ API
5. Go to credentials
6. Go to OAuth consent screen and fill in the details
7. Go to credentials screen and hit create credentials. Save your CLIENT ID and CLIENT SECRET. Will need these later.
8. Choose web application and OAuth client ID. 
9. Enter http://localhost:3000/auth/google_oauth2/callback for the authorized redirect URIs

## Setting up Rails Repo ##
1. Now, go to your ruby on rails application
2. In your gemfile, add *gem 'omniauth-google-oauth2', '~> 0.2.1'*.
3. Run *bundle install*.
3.5. Make a new model/view/controller for posts using:
```shell
rails scaffold Posts title:string description:string upvotes:integer
```
4. Create a new file in *config/initializers* called *omniauth.rb* with:
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
This step connects the application to your specific Google API project.
5. In your terminal, navigate to the root of your project directory and run the following commands:
```shell
rails g model user provider uid name oauth_token oauth_expires_at:datetime
rake db:migrate
```
This step creates the model to store user information.
6. In the same terminal/directory, run the following commands:
```shell
rails g controller login index
rails g controller Sessions create destroy
```
The first command creates the controller for the landing page and the second command creates the controller for Sessions (logging in/out).
7. Now in the  *config/routes.rb* file, add the following lines of code to allow the google authentication routes to work with your project:
```ruby
	get 'auth/:provider/callback', to: 'sessions#create'
	get 'auth/failure', to: redirect('/')
	get 'signout', to: 'sessions#destroy', as: 'signout'

	resources :sessions, only: [:create, :destroy]
	root "login#index"
```
The routes file should also have *resources :posts*. Leave that in there.
8. Add these lines of code to your *User* class in *app/models/user.rb*:
```ruby
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end
```
This handles the user data when someone logs in.
