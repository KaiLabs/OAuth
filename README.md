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
1. Create a new Rails Repo; name it whatever you want.
2. In your gemfile, add *gem 'omniauth-google-oauth2', '~> 0.2.1'*
3. Run *bundle install*

3.5 Make a new model/view/controller for posts using:
```shell
rails generate scaffold Posts title:string description:string upvotes:integer
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
rails db:migrate
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
This handles the logic with the user data when someone logs in.
9. Add these lines to your class in *app/controllers/application_controller.rb*:
```ruby
  helper_method :current_user
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
```
This checks to see if the user_id is already inside of session.
10. Add these two methods to your *SessionsController* class in *app/controllers/session_controller.rb*:
```ruby
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
      redirect_to posts_path
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
```
These connect your login/logout to specific paths. Instead of posts_path, put the landing page for your own website.
11. Add these lines of HTML to your *app/views/login/index.html.erb*:
```html
<!DOCTYPE html>
<html>
  <head>
    <title>Google Auth Example App</title>
    <%= stylesheet_link_tag    "application", media: "all", "data-turbolinks-track" => true %>
    <%= javascript_include_tag "application", "data-turbolinks-track" => true %>
    <%= csrf_meta_tags %>
  </head>
  <body>
    <div>
      <% if current_user %>
        Signed in as <strong><%= current_user.name %></strong>!
        <%= link_to "Sign out", signout_path, id: "sign_out" %>
      <% else %>
        <%= link_to "Sign in with Google", "/auth/google_oauth2", id: "sign_in" %>
      <% end %>
    </div>
  </body>
</html>
```
12. Add these lines of HTML to your *app/views/posts/index.html.erb* on the top of the page:
```html
<%= link_to "Sign out", signout_path, id: "sign_out" %>
```
13. Start up your server with *rails server* and try logging in/out!

## Some extra fancy stuff ##
1. Add these methods to your *app/controllers/application_controller.rb*:
```ruby
def authenticate_user
  if session[:user_id] == nil
    redirect_to(:controller => 'login', :action => 'index')
    return false
  else
    return true	
  end
end

def save_login_state
  if session[:user_id]
    flash[:error] = "You must logout to leave!"
    redirect_to(:controller => 'posts', :action => 'index')
    return false
  else
    return true
  end
end
```
2. At the top of the class in *app/controllers/posts_controller.rb*, add:
```ruby
before_filter :authenticate_user
```
3. At the top of the class in *app/controllers/login_controller.rb*, add:
```ruby
before_filter :save_login_state, :only => [:index]
```

## Adding Admin Powers ##

1. Generate a migration to add the admin attribute to a user.
```shell
rails generate migration AddAdminToUsers admin:boolean
```
2. Add *default: false* to the end of the add_column line in the migration.
It should look like *add_column :users, :admin, :boolean, default: false*

3. rake db:migrate

## Adding Admin Users ##

I thought of two decent ways of making a user an admin:
1. Promote a user to admin on creation:

In your self.from_omniauth method in your User model, you can add a conditional check like:
```ruby
# If you don't have an 'email' attribute in your Users model that's fine, just don't do that check.
if user.name == "Daichi Onda" or user.email =="moreyes@wesleyan.edu"
  user.admin = true
else
  user.admin = false
end
```
2. Promote a user to admin on some event:

If you want to make it something that happens if they visit a page, you can add this line to the controller:
```ruby
@current_user = User.find_by id: session[:user_id]
  # some random conditional
  if @current_user.name == "Timothy Kim" or @current_user.name == "Tim Kim"
    @current_user.update_attribute :admin, true
  end
```

## Making Things Admin Only ##

```ruby
if current_user.admin?
  # do something
end
```

A good example of when this might be useful is when you want to limit who can create or delete a post.
