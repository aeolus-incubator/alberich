require 'spec_helper'

module Alberich
  describe PermissionsController do

    before(:each) do
      @admin_permission = FactoryGirl.create(:admin_permission)
      @admin = @admin_permission.user
      mock_warden(@admin)

      @permission = FactoryGirl.create(:global_permission)
    end

    describe "GET index" do
      it "assigns all permissions as @permissions" do
        get :index, {}
        assigns(:permissions).should include(@permission)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Permission" do
          expect {
            post :create, {:entity_role_selected =>
              [[Entity.for_target(FactoryGirl.create(:user)).id,
                FactoryGirl.create(:role).id].join(",")]}
          }.to change(Permission, :count).by(1)
        end

        it "redirects to index for global permission" do
          post :create, {:entity_role_selected =>
            [[Entity.for_target(FactoryGirl.create(:user)).id,
              FactoryGirl.create(:role).id].join(",")]}
          response.should redirect_to(permissions_path(:return_from_permission_change => true))
        end
      end

      describe "with invalid params" do
        it "shows proper error message" do
          # Trigger the behavior that occurs when invalid params are submitted
          Permission.any_instance.stub(:save).and_return(false)
          post :create, {:entity_role_selected => []}
          flash[:error].should eq("No users or groups selected")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested permission" do
          # Assuming there are no other permissions in the database, this
          # specifies that the Permission created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          old_role = @permission.role
          new_role = FactoryGirl.create(:role)
          @permission.role.should eq(old_role)
          put :multi_update, {:permission_role_selected =>
            [[@permission.id,
              new_role.id].join(",")]}
          @permission.reload
          @permission.role.should eq(new_role)
        end

        it "redirects to the index for global permissions" do
          put :multi_update, {:permission_role_selected =>
            [[@permission.id,
              FactoryGirl.create(:role).id].join(",")]}
          response.should redirect_to(permissions_path(:return_from_permission_change => true))
        end

      end

      describe "with invalid params" do
        it "assigns the permission as @permission" do
          # Trigger the behavior that occurs when invalid params are submitted
          permission2 = FactoryGirl.create(:global_permission, :entity => @permission.entity)
          permission2.entity.should eq(@permission.entity)
          permission2.permission_object.should eq(@permission.permission_object)
          Permission.any_instance.stub(:save).and_return(false)
          put :multi_update, {:permission_role_selected =>
            ["#{@permission.id},#{permission2.role.id}"]}
          flash[:error].should include("Could not add")
        end

        it "returns to index for global permission" do
          permission2 = FactoryGirl.create(:global_permission, :entity => @permission.entity)
          permission2.entity.should eq(@permission.entity)
          permission2.permission_object.should eq(@permission.permission_object)
          Permission.any_instance.stub(:save).and_return(false)
          put :multi_update, {:permission_role_selected =>
            ["#{@permission.id},#{permission2.role.id}"]}
          response.should redirect_to(permissions_path(:return_from_permission_change => true))
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested permission" do
        expect {
          delete :multi_destroy, {:permission_selected => [@permission.to_param]}
        }.to change(Permission, :count).by(-1)
      end

      it "redirects to the permissions list" do
        delete :multi_destroy, {:permission_selected => [@permission.to_param]}
        response.should redirect_to(permissions_path(:return_from_permission_change => true))
      end
    end
  end
end
