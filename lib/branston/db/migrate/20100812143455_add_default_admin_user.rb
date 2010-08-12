class AddDefaultAdminUser < ActiveRecord::Migration
  def self.up
    u = User.new
    u.login = "admin"
    u.password = "password"
    u.password_confirmation = "password"
    u.email = "foo@bar.org"
    u.state = "active"
    u.activated_at = Time.now
    u.is_admin = true
    u.save!
  end

  def self.down
  end
end

