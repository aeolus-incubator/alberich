require 'spec_helper'

module Alberich
  describe PrivilegesController do

    before(:each) do
      @role = FactoryGirl.create(:role)
      @privilege = FactoryGirl.create(:privilege, :role_id => @role.id)
      @admin_permission = FactoryGirl.create(:admin_permission)
      @admin = @admin_permission.user
      mock_warden(@admin)
    end

    describe "GET index" do
      it "assigns all privileges as @privileges" do
        get :index, {}
        assigns(:privileges).should include(@privilege)
      end
    end

    describe "GET show" do
      it "assigns the requested privilege as @privilege" do
        get :show, {:id => @privilege.to_param}
        assigns(:privilege).should eq(@privilege)
      end
    end

    describe "GET new" do
      it "assigns a new privilege as @privilege" do
        get :new, {}
        assigns(:privilege).should be_a_new(Privilege)
      end
    end

    describe "GET edit" do
      it "assigns the requested privilege as @privilege" do
        get :edit, {:id => @privilege.to_param}
        assigns(:privilege).should eq(@privilege)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Privilege" do
          expect {
            post :create, {:privilege => FactoryGirl.attributes_for(:privilege, :role_id => @role.id, :action => "modify").symbolize_keys}
          }.to change(Privilege, :count).by(1)
        end

        it "assigns a newly created privilege as @privilege" do
          post :create, {:privilege => FactoryGirl.attributes_for(:privilege, :role_id => @role.id, :action => "modify").symbolize_keys}
          assigns(:privilege).should be_a(Privilege)
          assigns(:privilege).should be_persisted
        end

        it "redirects to the created privilege" do
          post :create, {:privilege => FactoryGirl.attributes_for(:privilege, :role_id => @role.id, :action => "modify").symbolize_keys}
          response.should redirect_to(@role)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved privilege as @privilege" do
          # Trigger the behavior that occurs when invalid params are submitted
          Privilege.any_instance.stub(:save).and_return(false)
          post :create, {:privilege => {}}
          assigns(:privilege).should be_a_new(Privilege)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Privilege.any_instance.stub(:save).and_return(false)
          post :create, {:privilege => {}}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested privilege" do
          # Assuming there are no other privileges in the database, this
          # specifies that the Privilege created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Privilege.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, {:id => @privilege.to_param, :privilege => {'these' => 'params'}}
        end

        it "assigns the requested privilege as @privilege" do
          put :update, {:id => @privilege.to_param, :privilege => FactoryGirl.attributes_for(:privilege, :role_id => @role.id, :action => "modify").symbolize_keys}
          assigns(:privilege).should eq(@privilege)
        end

        it "redirects to the privilege" do
          put :update, {:id => @privilege.to_param, :privilege => FactoryGirl.attributes_for(:privilege, :role_id => @role.id, :action => "modify").symbolize_keys}
          response.should redirect_to(@role)
        end
      end

      describe "with invalid params" do
        it "assigns the privilege as @privilege" do
          # Trigger the behavior that occurs when invalid params are submitted
          Privilege.any_instance.stub(:save).and_return(false)
          put :update, {:id => @privilege.to_param, :privilege => {}}
          assigns(:privilege).should eq(@privilege)
        end

        it "re-renders the 'edit' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Privilege.any_instance.stub(:save).and_return(false)
          put :update, {:id => @privilege.to_param, :privilege => {}}
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested privilege" do
        expect {
          delete :destroy, {:id => @privilege.to_param}
        }.to change(Privilege, :count).by(-1)
      end

      it "redirects to the privileges list" do
        delete :destroy, {:id => @privilege.to_param}
        response.should redirect_to(@role)
      end
    end
  end
end
