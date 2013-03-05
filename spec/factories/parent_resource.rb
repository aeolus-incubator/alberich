FactoryGirl.define do

  factory :parent_resource do |u|
    sequence(:name) { |n| "parent_resource#{n}" }
    description 'The Description'
  end

  factory :parent_resource2, :parent => :parent_resource do |u|
    sequence(:name) { |n| "parent_resource_test" }
    description 'The Description'
  end
end
