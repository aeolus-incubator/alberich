class ParentResource < ActiveRecord::Base
  has_many :child_resources
  attr_accessible :description, :name

  include Alberich::PermissionedObject

  # for objects with a user or owner attribute, owner-level privileges
  # can automatically be conferred with the following
  #   after_create "assign_owner_roles(owner)"
  # otherwise this will need to be handled explicitly in the
  # controller create action

  # We don't need to override perm_ancestors since this type doesn't
  # inherit from anything

  # We don't need to override derived_subtree since nothing inherits
  # from this type
  def derived_subtree(role = nil)
    subtree = super(role)
    if (role.nil? || role.privilege_target_match(ChildResource))
      subtree += child_resources
    end
    subtree
  end

  # Other resource types for which we need to allow privileges at this
  # level (often objects which sub-resources this type)
  def self.additional_privilege_target_types
    [ChildResource]
  end

end
