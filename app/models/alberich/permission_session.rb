module Alberich
  class PermissionSession < ActiveRecord::Base
    attr_accessible :session_id, :user_id, :user

    belongs_to :user, :class_name => Alberich.user_class

    validates_presence_of :user_id
    validates_presence_of :session_id

    def update_session_entities(user)
      # FIXME SessionEntity.transaction do
        # skips callbacks, which should be fine here
      #  SessionEntity.delete_all(:permission_session_id => self.id)
      #  add_to_session(user)
      #end
    end

  def add_to_session(user)
    return unless user
    # create mapping for user-level permissions
    # FIXME SessionEntity.create!(:permission_session_id => self.id,
    #                      :user => user,
    #                      :entity => user.entity)
    # create mappings for local groups
    user.send(Alberich.groups_for_user_method).each do |ug|
      # FIXME SessionEntity.create!(:permission_session_id => self.id,
      #                      :user => user,
      #                      :entity => ug.entity)
    end
  end
  end
end
