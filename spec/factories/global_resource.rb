FactoryGirl.define do

  factory :global_resource do |u|
    sequence(:name) { |n| "global_resource#{n}" }
    description 'The Description'
  end

  factory :global_resource2 , :parent => :global_resource do
    name 'Test global resoource'
  end
end
