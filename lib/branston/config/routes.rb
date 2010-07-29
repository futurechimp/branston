ActionController::Routing::Routes.draw do |map|

  # Resources
  #
  map.resources :iterations do |i|
    i.resources :stories, :member => { :generate_feature => :get } do |r|
      r.resources :scenarios
    end
  end
  map.resources :outcomes
  map.resources :preconditions
  map.resources :releases
  map.resource :session
  map.resources :user_roles
  map.resources :users, :member => { :suspend => :get, :activate => :get }

  # Named routes
  #
  map.client_generate '/stories/:id.:format', :controller => 'stories', :action => 'show'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'

  # Defaults
  #
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

  # root_path
  #
  map.root :controller => :iterations

end

