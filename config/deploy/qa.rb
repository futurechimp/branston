role :app, "branston.headlondon.office"
role :web, "branston.headlondon.office"
role :db,  "branston.headlondon.office", :primary => true

set :scm, "git"
set :user, "capistrano"
set :deploy_to, "/var/www/branston.headlondon.office/"
set :repository, "git@github.com:steventux/branston.git"
set :rails_env, :qa

