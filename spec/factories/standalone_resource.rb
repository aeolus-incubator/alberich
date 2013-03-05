FactoryGirl.define do

  factory :standalone_resource do |u|
    sequence(:name) { |n| "standalone_resource#{n}" }
    description 'The Description'
  end
end
