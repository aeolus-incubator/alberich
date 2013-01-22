require 'spec_helper'

module Alberich
  describe Entity do
    it "should create entity on user creation" do
      u = FactoryGirl.create(:user)
      Entity.for_target(u).should be_a(Entity)
    end

    it "should create entity on user group creation" do
      u = FactoryGirl.create(:user_group)
      Entity.for_target(u).should be_a(Entity)
    end
  end
end
