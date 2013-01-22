FactoryGirl.define do
  factory :privilege, :class => Alberich::Privilege do
    target_type 'Alberich::BasePermissionObject'
    action 'view'
  end
end
