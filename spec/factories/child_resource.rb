FactoryGirl.define do

  factory :child_resource do |u|
    sequence(:name) { |n| "child_resource#{n}" }
    association :parent_resource, :factory => :parent_resource
    description 'The Description'
  end

  factory :child_resource2, :parent => :child_resource do |u|
    sequence(:name) { |n| "child_resource_test" }
    parent_resource { |r| ParentResource.first(:conditions => ['name = ?', 'parent_resource_test']) || FactoryGirl.create(:parent_resource2) }
    description 'The Description'
  end
end
