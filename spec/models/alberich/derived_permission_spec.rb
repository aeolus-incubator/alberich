require 'spec_helper'

module Alberich
  describe DerivedPermission do
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

    it "derived permissions created for global permission" do
      derived_perms_count = BasePermissionObject.general_permission_scope.
        derived_permissions.size
      @global_perm = Permission.create(:entity => Entity.for_target(@admin),
                                       :role => FactoryGirl.create(:role),
                                       :permission_object =>
                                       BasePermissionObject.general_permission_scope)
      perm_sources = BasePermissionObject.general_permission_scope.
        derived_permissions.collect {|p| p.permission}
      perm_sources.size.should == (derived_perms_count + 1)
      perm_sources.include?(@admin_permission).should be_true
      perm_sources.include?(@global_perm).should be_true
    end
    #FIXME add obj-level tests with inheritence once dummy app gets permissioned object examples

  end
end
