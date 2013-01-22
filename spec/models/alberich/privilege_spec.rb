require 'spec_helper'

module Alberich
  describe Privilege do
    it "should require unique action for target and role" do
      role1 = FactoryGirl.create(:role)
      role2 = FactoryGirl.create(:role)
      priv1 = FactoryGirl.create(:privilege, :action => "create",
                                 :target_type => "Alberich::BasePermissionObject",
                                 :role_id => role1.id)
      priv2 = FactoryGirl.create(:privilege, :action => "create",
                                 :target_type => "Alberich::BasePermissionObject",
                                 :role_id => role2.id)
      priv2.role = priv1.role
      priv2.should_not be_valid
    end
    it "should enforce validity of action" do
      role1 = FactoryGirl.create(:role)
      u = FactoryGirl.create(:privilege, :role_id => role1.id)
      u.valid?.should be_true
      u.action = "I'm Invalid"
      u.valid?.should be_false
      u.errors[:action].should_not be_nil
      u.errors[:action][0].should =~ /^is not included in the list.*/
    end

    it "should enforce validity of target_type" do
      role1 = FactoryGirl.create(:role)
      u = FactoryGirl.create(:privilege, :role_id => role1.id)
      u.valid?.should be_true
      u.target_type = "I'm Invalid"
      u.valid?.should be_false
      u.errors[:target_type].should_not be_nil
      u.errors[:target_type][0].should =~ /^is not included in the list.*/
    end


  end
end
