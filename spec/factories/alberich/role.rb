FactoryGirl.define do
  factory :role, :class => Alberich::Role do
    sequence(:name) { |n| "role#{n}" }
    scope 'Alberich::BasePermissionObject'
  end

  factory :admin_role, :parent => :role do
    name 'Site Admin'
    after(:create) do |role, evaluator|
      priv_data = [["Alberich::BasePermissionObject", "create"],
                   ["Alberich::BasePermissionObject", "modify"],
                   ["Alberich::BasePermissionObject", "use"],
                   ["Alberich::BasePermissionObject", "set_perms"],
                   ["Alberich::BasePermissionObject", "view_perms"],
                   ["Alberich::BasePermissionObject", "view"],
                   ["User", "view_perms"],
                   ["User", "set_perms"],
                   [ "User", "view"],
                   [ "User", "create"],
                   ["User", "modify"],
                   ["GlobalResource", "view"],
                   ["GlobalResource", "modify"],
                   ["GlobalResource", "create"],
                   ["StandaloneResource", "create"],
                   ["StandaloneResource", "view"],
                   ["StandaloneResource", "modify"],
                   ["ParentResource", "create"],
                   ["ParentResource", "view"],
                   ["ParentResource", "modify"],
                   ["ChildResource", "create"],
                   ["ChildResource", "view"],
                   ["ChildResource", "modify"]]
      priv_data.each do |target_type, action|
        FactoryGirl.create(:privilege, :target_type => target_type,
                           :action => action, :role_id => role.id)
      end
    end
  end

  factory :global_resource_role, :parent => :role do
    name 'GlobalResource Admin'
    after(:create) do |role, evaluator|
      priv_data = [["GlobalResource", "view"],
                   ["GlobalResource", "modify"],
                   ["GlobalResource", "create"]]
      priv_data.each do |target_type, action|
        FactoryGirl.create(:privilege, :target_type => target_type,
                           :action => action, :role_id => role.id)
      end
    end
  end

  factory :standalone_creator_role, :parent => :role do
    name 'StandaloneResource Creator'
    after(:create) do |role, evaluator|
      priv_data = [["StandaloneResource", "create"]]
      priv_data.each do |target_type, action|
        FactoryGirl.create(:privilege, :target_type => target_type,
                           :action => action, :role_id => role.id)
      end
    end
  end
  factory :standalone_owner_role, :parent => :role do
    name 'StandaloneResource Owner'
    scope 'StandaloneResource'
    after(:create) do |role, evaluator|
      priv_data = [["StandaloneResource", "view"],
                  ["StandaloneResource", "modify"]]
      priv_data.each do |target_type, action|
        FactoryGirl.create(:privilege, :target_type => target_type,
                           :action => action, :role_id => role.id)
      end
    end
  end

  factory :parent_owner_role, :parent => :role do
    name 'ParentResource Owner'
    scope 'ParentResource'
    after(:create) do |role, evaluator|
      priv_data = [["ChildResource", "view"],
                  ["ChildResource", "modify"],
                  ["ChildResource", "create"],
                  ["ParentResource", "view"],
                  ["ParentResource", "modify"]]
      priv_data.each do |target_type, action|
        FactoryGirl.create(:privilege, :target_type => target_type,
                           :action => action, :role_id => role.id)
      end
    end
  end
  factory :child_owner_role, :parent => :role do
    name 'ChildResource Owner'
    scope 'ChildResource'
    after(:create) do |role, evaluator|
      priv_data = [["ChildResource", "view"],
                  ["ChildResource", "modify"]]
      priv_data.each do |target_type, action|
        FactoryGirl.create(:privilege, :target_type => target_type,
                           :action => action, :role_id => role.id)
      end
    end
  end
end
