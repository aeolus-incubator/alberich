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

  factory :global_resource_permission, :parent => :permission do
    role { |r| Alberich::Role.first(:conditions => ['name = ?', 'GlobalResource Admin']) || FactoryGirl.create(:global_resource_role) }
    permission_object { |r| Alberich::BasePermissionObject.general_permission_scope }
    entity { |r| Alberich::Entity.for_target(FactoryGirl.create(:user)) }
  end

  factory :standalone_creator_permission, :parent => :permission do
    role { |r| Alberich::Role.first(:conditions => ['name = ?', 'StandaloneResource Creator']) || FactoryGirl.create(:standalone_creator_role) }
    permission_object { |r| Alberich::BasePermissionObject.general_permission_scope }
    entity { |r| Alberich::Entity.for_target(FactoryGirl.create(:user)) }
  end
  factory :standalone_owner_permission, :parent => :permission do
    role { |r| Alberich::Role.first(:conditions => ['name = ?', 'StandaloneResource Owner']) || FactoryGirl.create(:standalone_owner_role) }
    permission_object { |r| FactoryGirl.create(:standalone_resource) }
    entity { |r| Alberich::Entity.for_target(FactoryGirl.create(:user)) }
  end

  factory :parent_owner_permission, :parent => :permission do
    role { |r| Alberich::Role.first(:conditions => ['name = ?', 'ParentResource Owner']) || FactoryGirl.create(:parent_owner_role) }
    permission_object { |r| FactoryGirl.create(:parent_resource2) }
    entity { |r| Alberich::Entity.for_target(FactoryGirl.create(:user)) }
  end
  factory :child_owner_permission, :parent => :permission do
    role { |r| Alberich::Role.first(:conditions => ['name = ?', 'ChildResource Owner']) || FactoryGirl.create(:child_owner_role) }
    permission_object { |r| FactoryGirl.create(:child_resource2) }
    entity { |r| Alberich::Entity.for_target(FactoryGirl.create(:user)) }
  end

end
