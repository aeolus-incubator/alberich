require 'spec_helper'

module Alberich
  describe Role do
    it "should not be valid if name is too long" do
      u = FactoryGirl.create(:role)
      u.name = ('a' * 256)
      u.valid?.should be_false
      u.errors[:name].should_not be_nil
      u.errors[:name][0].should =~ /^is too long.*/
    end

    it "should enforce validity of scope" do
      u = FactoryGirl.create(:role)
      u.valid?.should be_true
      u.scope = "I'm Invalid"
      u.valid?.should be_false
      u.errors[:scope].should_not be_nil
      u.errors[:scope][0].should =~ /^is not included in the list.*/
    end

    it "should require unique name" do
      role1 = FactoryGirl.create(:role)
      role2 = FactoryGirl.create(:role)
      role1.should be_valid
      role2.should be_valid

      role2.name = role1.name
      role2.should_not be_valid
    end

  end
end
