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
                   ["User", "modify"]]
      priv_data.each do |target_type, action|
        FactoryGirl.create(:privilege, :target_type => target_type,
                           :action => action, :role_id => role.id)
      end
    end
  end
end
