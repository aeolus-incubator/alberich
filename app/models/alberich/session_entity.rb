module Alberich
  class SessionEntity < ActiveRecord::Base
    attr_accessible :entity_id, :permission_session_id, :user_id,
                    :entity, :user
    belongs_to :user
    belongs_to :entity
    belongs_to :permission_session

    validates_presence_of :user_id
    validates_presence_of :permission_session_id
    validates_presence_of :entity_id
    validates_uniqueness_of :entity_id, :scope => [:user_id, :permission_session_id]

  end
end
