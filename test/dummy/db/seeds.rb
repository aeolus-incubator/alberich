# created admin user admin/password
user = User.find_by_username("admin")
unless user
  user = User.new(:username => "admin", :email => "admin@example.com",
                  :password => "password",
                  :password_confirmation => "password",
                  :first_name => "Admin",
                  :last_name  => "User")
  user.save!
end
