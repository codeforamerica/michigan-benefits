require 'rails_helper'

describe Admin::AccountsController do
  describe 'not admin' do
    it 'redirects to login' do
      get :index
      expect(response).to be_redirect
    end
  end

  describe 'authenticated' do
    let(:valid_attributes) {
      { email: 'bob2@example.com', password: 'a password' }
    }

    let(:invalid_attributes) {
      { email: '' }
    }

    before do
      account = create :account
      account.roles << create(:admin_role)
      login_user account
    end

    describe "GET index" do
      it "assigns all accounts as @accounts" do
        get :index, {}
        expect(assigns(:accounts)).to eq(Account.all)
      end
    end

    describe "GET show" do
      it "assigns the requested account as @account" do
        account = Account.create! valid_attributes
        get :show, {:id => account.to_param}
        expect(assigns(:account)).to eq(account)
      end
    end

    describe "GET new" do
      it "assigns a new account as @account" do
        get :new, {}
        expect(assigns(:account)).to be_a_new(Account)
      end
    end

    describe "GET edit" do
      it "assigns the requested account as @account" do
        account = Account.create! valid_attributes
        get :edit, {:id => account.to_param}
        expect(assigns(:account)).to eq(account)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Account" do
          expect {
            post :create, {:account => valid_attributes}
          }.to change(Account, :count).by(1)
        end

        it "assigns a newly created account as @account" do
          post :create, {:account => valid_attributes}
          expect(assigns(:account)).to be_a(Account)
          expect(assigns(:account)).to be_persisted
        end

        it "assigns roles" do
          post :create, {:account => valid_attributes.merge(role_ids: [Role.admin.id])}
          expect(Role).to be_admin assigns(:account)
        end

        it "redirects to the created account" do
          post :create, {:account => valid_attributes}
          expect(response).to redirect_to(admin_account_path(Account.last))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved account as @account" do
          post :create, {:account => invalid_attributes}
          expect(assigns(:account)).to be_a_new(Account)
        end

        it "re-renders the 'new' template" do
          post :create, {:account => invalid_attributes}
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        let(:new_attributes) {
          { email: 'bob3@example.com' }
        }

        it "updates the requested account" do
          account = Account.create! valid_attributes
          put :update, {:id => account.to_param, :account => new_attributes}
          account.reload
          expect(account.email).to eq(new_attributes[:email])
        end

        it "assigns the requested account as @account" do
          account = Account.create! valid_attributes
          put :update, {:id => account.to_param, :account => valid_attributes}
          expect(assigns(:account)).to eq(account)
        end

        it "redirects to the account" do
          account = Account.create! valid_attributes
          put :update, {:id => account.to_param, :account => valid_attributes}
          expect(response).to redirect_to(admin_account_path(account))
        end
      end

      describe "with invalid params" do
        it "assigns the account as @account" do
          account = Account.create! valid_attributes
          put :update, {:id => account.to_param, :account => invalid_attributes}
          expect(assigns(:account)).to eq(account)
        end

        it "re-renders the 'edit' template" do
          account = Account.create! valid_attributes
          put :update, {:id => account.to_param, :account => invalid_attributes}
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested account" do
        account = Account.create! valid_attributes
        expect {
          delete :destroy, {:id => account.to_param}
        }.to change(Account, :count).by(-1)
      end

      it "redirects to the accounts list" do
        account = Account.create! valid_attributes
        delete :destroy, {:id => account.to_param}
        expect(response).to redirect_to(admin_accounts_url)
      end
    end
  end
end
