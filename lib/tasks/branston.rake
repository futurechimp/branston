namespace :branston do

  desc <<-DESC
  Create a default dev admin user
  To run: rake branston:create_dev_admin_user
  DESC
  task :create_dev_admin_user => :environment do
    u = User.new
    u.login = "devadmin"
    u.name = "Dev Admin"
    u.email = "devadmin@branston.com"
    u.password = "password"
    u.password_confirmation = "password"
    u.role = "admin"
    u.save!
  end
  
end
