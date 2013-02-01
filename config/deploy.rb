require 'capistrano/ext/multistage'
require 'bundler/capistrano'

set :application, "branston"
set :use_sudo, false
set :scm_username, Proc.new { Capistrano::CLI.ui.ask('SVN User: ') }
set :scm_password, Proc.new { Capistrano::CLI.password_prompt('SVN Password: ') }

set :keep_releases, 2
# Let's try caching the source code on the server so that deploys go quicker.
set :deploy_via, :remote_cache

default_run_options[:pty]=true

desc <<-DESC
Does a clean deploy by removing the cached-copy folder first,
then runs deploy.full
To run: cap RAILS_ENV deploy:clean_deploy
RAILS_ENV = Is the rails environment to deploy to
DESC
deploy.task :clean do
  deploy.remove_cached
  deploy.full
end

desc <<-DESC
Does a full deploy, then syncs all statics.
To run: cap RAILS_ENV deploy:full
RAILS_ENV = Is the rails environment to deploy to
DESC
deploy.task :full do
  transaction do
    update_code
#    deploy.web:disable
    symlink
    cpdbconfig
    migrate
  end
  restart
#  deploy.web:enable
  cleanup
end

namespace :deploy do
  desc <<-DESC
  Removes the cached-copy folder.
  To run: cap RAILS_ENV update_projects:remove_cached
  RAILS_ENV = Is the rails environment to deploy to
  DESC
  task :remove_cached do
    run("rm -rf #{deploy_to}shared/cached-copy")
  end

  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  desc "Copy the release database.yml file into place after the code deploys."
  task :cpdbconfig  do
    db_config = "#{shared_path}/database.yml"
    run "cp #{db_config} #{release_path}/config/database.yml"
  end
  
end

desc "Copy the release database.yml file into place after the code deploys."
deploy.task :after_update_code, :roles => :app  do
  db_config = "#{shared_path}/database.yml"
  run "cp #{db_config} #{release_path}/config/database.yml"
end
