FactoryGirl.define do

  factory :user do |u|
    sequence(:username) { |n| "user#{n}" }
    password 'secret'
    password_confirmation 'secret'
    first_name 'John'
    last_name 'Smith'
    email "#{:username}@example.com"
    #after_build { |u| u.email ||= "#{u.username}@example.com" }
  end

  factory :email_user , :parent => :user do
    email = :email
  end

  factory :other_named_user, :parent => :user do
    first_name 'Jane'
    last_name 'Doe'
  end

  factory :tuser, :parent => :user do
    last_login_ip '192.168.1.1'
  end

  factory :admin_user, :parent => :user do
    username 'admin'
  end

end
