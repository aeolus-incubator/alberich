class StandaloneResource < ActiveRecord::Base
  attr_accessible :description, :name

  include Alberich::PermissionedObject

  # for objects with a user or owner attribute, owner-level privileges
  # can automatically be conferred with the following
  #   after_create "assign_owner_roles(owner)"
  # otherwise this will need to be handled explicitly in the
  # controller create action

  # We don't need to override perm_ancesstors since this type doesn't
  # inherit from anything

  # We don't need to override derived_subtree since nothing inherits
  # from this type

  # We don't need to override additional_privilege_target_types since
  # there are not other privilege types  that need to be set on this
  # model's roles

end
