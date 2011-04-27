namespace :db do
  desc "Make a pristine copy of the development database for use in the gem" 
  task :make_pristine_copy => [:environment, 'db:backup_development', 'db:reset',
  'db:copy_to_pristine', 'db:restore_development']
  
  task :copy_to_pristine => :environment do
    `cp -f db/development.sqlite3 db/pristine.sqlite3`
  end
  
  task :backup_development => :environment do
    `cp db/development.sqlite3 db/tmp.sqlite3`
  end
  
  task :restore_development => :environment do
    `cp -f db/tmp.sqlite3 db/development.sqlite3`
    `rm db/tmp.sqlite3`
  end
end
