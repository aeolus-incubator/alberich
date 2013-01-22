require 'spec_helper'

module Alberich
  describe Permission do
    before(:each) do
      @admin_permission = FactoryGirl.create :admin_permission
      @permission = FactoryGirl.create :global_permission

      @admin = @admin_permission.user
      @user = @permission.user
      @permission_session = FactoryGirl.create(:permission_session,
                                               :user => @admin)
      @permission_session.update_session_entities(@admin)
      @permission_session.add_to_session(@user)

    end

    it "Admin should be able to create users" do
      BasePermissionObject.general_permission_scope.
        has_privilege(@permission_session,
                      @admin,
                      Privilege::CREATE,
                      User).should be_true
    end

    it "Non-admin should be able to create users" do
      BasePermissionObject.general_permission_scope.
        has_privilege(@permission_session,
                      @user,
                      Privilege::CREATE,
                      User).should be_false
    end

    it "User added to Admin group should be able to create users" do
      newuser = FactoryGirl.create(:user)
      group_admin_permission = FactoryGirl.create(:group_admin_permission)
      user_group = group_admin_permission.user_group
      @permission_session.update_session_entities(newuser)
      BasePermissionObject.general_permission_scope.has_privilege(@permission_session,
                                                                  newuser,
                                                                  Privilege::CREATE,
                                                                  User).should be_false
      user_group.members << newuser
      newuser.reload
      @permission_session.update_session_entities(newuser)
      BasePermissionObject.general_permission_scope.has_privilege(@permission_session,
                                                                  newuser,
                                                                  Privilege::CREATE,
                                                                  User).should be_true

    end
    #FIXME add obj-level tests once dummy app gets permissioned object examples
  end
end
