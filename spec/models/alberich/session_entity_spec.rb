require 'spec_helper'

module Alberich
  describe SessionEntity do
    it "should require unique entity for user and session" do
      user = FactoryGirl.create(:user)
      group1 = FactoryGirl.create(:user_group)
      group2 = FactoryGirl.create(:user_group)
      session = FactoryGirl.create(:permission_session, :user_id=>user.id)
      entity1 = SessionEntity.new(:permission_session_id => session.id,
                                  :user_id => user.id,
                                  :entity_id => Entity.for_target(group1).id)
      entity1.should be_valid
      entity1.save!
      entity2 = SessionEntity.new(:permission_session_id => session.id,
                                  :user_id => user.id,
                                  :entity_id => Entity.for_target(group2).id)
      entity2.should be_valid
      entity2.entity = entity1.entity
      entity2.should_not be_valid
    end

  end
end
