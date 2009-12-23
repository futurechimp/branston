ActionController::Routing::Routes.draw do |map|
  map.resources :outcomes

  map.resources :preconditions

  map.resources :releases
  map.resources :iterations do |i|
    i.resources :stories, :member => { :generate_feature => :get } do |r|
      r.resources :scenarios
    end
  end

  map.resources :user_roles

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.resources :users

  map.resource :session
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

  map.root :controller => :iterations
end

