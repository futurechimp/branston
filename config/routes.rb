ActionController::Routing::Routes.draw do |map|

  # Resources
  #
	map.resources :projects do |project|
	  project.resources :iterations, :except => [:index]
	end
	
	map.resources :iterations, :only => [] do |iteration|
    iteration.resources :stories, :member => { :generate_feature => :get } do |story|
      story.resources :scenarios, :except => [:index, :show, :edit, :update]
    end
  end

  map.resources :outcomes, :except => [:index, :show, :edit, :update]
  map.resources :preconditions, :except => [:index, :show, :edit, :update]
  map.resource :session
  map.resources :users, :member => { :suspend => :get, :activate => :get }
	map.resources :releases
	
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
  map.root :controller => :projects

end

