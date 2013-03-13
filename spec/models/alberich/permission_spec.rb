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

    it "Non-admin should not be able to create users" do
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

    it "global permissions should be type-specific" do
      global_resource_permission = FactoryGirl.create :global_resource_permission
      global_resource_user = global_resource_permission.user
      @permission_session.update_session_entities(global_resource_user)
      BasePermissionObject.general_permission_scope.
        has_privilege(@permission_session,
                      global_resource_user,
                      Privilege::CREATE,
                      GlobalResource).should be_true
      BasePermissionObject.general_permission_scope.
        has_privilege(@permission_session,
                      @user,
                      Privilege::CREATE,
                      GlobalResource).should be_false
    end

    it "standalone resource create permission should be limited by global roles" do
      standalone_creator_permission = FactoryGirl.create :standalone_creator_permission
      standalone_creator_user = standalone_creator_permission.user
      @permission_session.update_session_entities(standalone_creator_user)
      BasePermissionObject.general_permission_scope.
        has_privilege(@permission_session,
                      standalone_creator_user,
                      Privilege::CREATE,
                      StandaloneResource).should be_true
      BasePermissionObject.general_permission_scope.
        has_privilege(@permission_session,
                      @user,
                      Privilege::CREATE,
                      StandaloneResource).should be_false
    end

    it "standalone resource access should be allowed for owner and admin" do
      standalone_owner_permission = FactoryGirl.create :standalone_owner_permission
      standalone_owner_user = standalone_owner_permission.user
      standalone_resource = standalone_owner_permission.permission_object
      @permission_session.add_to_session(standalone_owner_user)
      standalone_resource.
        has_privilege(@permission_session,
                      standalone_owner_user,
                      Privilege::VIEW).should be_true
      standalone_resource.
        has_privilege(@permission_session,
                      @admin,
                      Privilege::VIEW).should be_true
      standalone_resource.
        has_privilege(@permission_session,
                      @user,
                      Privilege::VIEW).should be_false
    end

    it "child resource access should inherit from parent" do
      parent_owner_permission = FactoryGirl.create :parent_owner_permission
      parent_owner_user = parent_owner_permission.user
      parent_resource = parent_owner_permission.permission_object
      @permission_session.add_to_session(parent_owner_user)

      child_owner_permission = FactoryGirl.create :child_owner_permission
      child_owner_user = child_owner_permission.user
      child_resource = child_owner_permission.permission_object
      @permission_session.add_to_session(child_owner_user)
      child_resource.
        has_privilege(@permission_session,
                      child_owner_user,
                      Privilege::VIEW).should be_true
      child_resource.
        has_privilege(@permission_session,
                      parent_owner_user,
                      Privilege::VIEW).should be_true
      child_resource.
        has_privilege(@permission_session,
                      @admin,
                      Privilege::VIEW).should be_true
      child_resource.
        has_privilege(@permission_session,
                      @user,
                      Privilege::VIEW).should be_false
    end
    #FIXME add obj-level tests once dummy app gets permissioned object examples
  end
end
