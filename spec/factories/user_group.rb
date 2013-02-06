FactoryGirl.define do

  factory :user_group do |u|
    sequence(:name) { |n| "group#{n}" }
  end


end
