require 'rails_helper'

describe Admin::RolesController do
  describe 'not admin' do
    it 'redirects to login' do
      get :index
      expect(response).to be_redirect
    end
  end

  describe 'authenticated' do
    let(:valid_attributes) {
      { name: 'A Role', key: 'a-role' }
    }

    let(:invalid_attributes) {
      { key: nil }
    }

    before do
      account = create :account
      account.roles << create(:admin_role)
      login_user account
    end

    describe "GET index" do
      it "assigns all roles as @roles" do
        role = Role.create! valid_attributes
        get :index, {}
        expect(assigns(:roles)).to eq(Role.all)
      end
    end

    describe "GET show" do
      it "assigns the requested role as @role" do
        role = Role.create! valid_attributes
        get :show, {:id => role.to_param}
        expect(assigns(:role)).to eq(role)
      end
    end

    describe "GET new" do
      it "assigns a new role as @role" do
        get :new, {}
        expect(assigns(:role)).to be_a_new(Role)
      end
    end

    describe "GET edit" do
      it "assigns the requested role as @role" do
        role = Role.create! valid_attributes
        get :edit, {:id => role.to_param}
        expect(assigns(:role)).to eq(role)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Role" do
          expect {
            post :create, {:role => valid_attributes}
          }.to change(Role, :count).by(1)
        end

        it "assigns a newly created role as @role" do
          post :create, {:role => valid_attributes}
          expect(assigns(:role)).to be_a(Role)
          expect(assigns(:role)).to be_persisted
        end

        it "redirects to the created role" do
          post :create, {:role => valid_attributes}
          expect(response).to redirect_to(admin_role_url(Role.last))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved role as @role" do
          post :create, {:role => invalid_attributes}
          expect(assigns(:role)).to be_a_new(Role)
        end

        it "re-renders the 'new' template" do
          post :create, {:role => invalid_attributes}
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        let(:new_attributes) {
          { name: 'A New Name' }
        }

        it "updates the requested role" do
          role = Role.create! valid_attributes
          put :update, {:id => role.to_param, :role => new_attributes}
          role.reload
          expect(role.name).to eq(new_attributes[:name])
        end

        it "assigns the requested role as @role" do
          role = Role.create! valid_attributes
          put :update, {:id => role.to_param, :role => valid_attributes}
          expect(assigns(:role)).to eq(role)
        end

        it "redirects to the role" do
          role = Role.create! valid_attributes
          put :update, {:id => role.to_param, :role => valid_attributes}
          expect(response).to redirect_to(admin_role_url(role))
        end
      end

      describe "with invalid params" do
        it "assigns the role as @role" do
          role = Role.create! valid_attributes
          put :update, {:id => role.to_param, :role => invalid_attributes}
          expect(assigns(:role)).to eq(role)
        end

        it "re-renders the 'edit' template" do
          role = Role.create! valid_attributes
          put :update, {:id => role.to_param, :role => invalid_attributes}
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested role" do
        role = Role.create! valid_attributes
        expect {
          delete :destroy, {:id => role.to_param}
        }.to change(Role, :count).by(-1)
      end

      it "redirects to the roles list" do
        role = Role.create! valid_attributes
        delete :destroy, {:id => role.to_param}
        expect(response).to redirect_to(admin_roles_url)
      end
    end
  end
end
