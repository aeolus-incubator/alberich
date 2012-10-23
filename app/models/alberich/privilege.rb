module Alberich
  class Privilege < ActiveRecord::Base
    attr_accessible :action, :role_id, :target_type

    PERM_SET  = "set_perms"    # can create/modify/delete permission
                               # records on this object
    PERM_VIEW = "view_perms"   # can view permission records on this
                               # object
    CREATE    = "create"       # can create objects of this type here
    MODIFY    = "modify"       # can modify objects of this type here
    VIEW      = "view"         # can view objects of this type here
    USE       = "use"          # can use objects of this type here

    ACTIONS = [ CREATE, MODIFY, USE, VIEW,
                PERM_SET, PERM_VIEW]

    belongs_to :role
    validates_presence_of :role_id
    validates_presence_of :target_type
    validates_presence_of :action
    validates_uniqueness_of :action, :scope => [:target_type, :role_id]

  end
end
