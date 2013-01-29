FactoryGirl.define do

  factory :permission, :class => Alberich::Permission

  factory :admin_permission, :parent => :permission do
    role { |r| Alberich::Role.first(:conditions => ['name = ?', 'Site Admin']) || FactoryGirl.create(:admin_role) }
    permission_object { |r| Alberich::BasePermissionObject.general_permission_scope }
    entity { |r| Alberich::Entity.for_target(FactoryGirl.create(:admin_user)) }
  end

  factory :group_admin_permission, :parent => :permission do
    role { |r| Alberich::Role.first(:conditions => ['name = ?', 'Site Admin']) || FactoryGirl.create(:admin_role) }
    permission_object { |r| Alberich::BasePermissionObject.general_permission_scope }
    entity { |r| Alberich::Entity.for_target(FactoryGirl.create(:user_group)) }
  end

  factory :global_permission, :parent => :permission do
    role { |r| FactoryGirl.create(:role) }
    permission_object { |r| Alberich::BasePermissionObject.general_permission_scope }
    entity { |r| Alberich::Entity.for_target(FactoryGirl.create(:user)) }
  end

end
