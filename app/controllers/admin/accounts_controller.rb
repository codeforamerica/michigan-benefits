class Admin::AccountsController < Admin::AdminBaseController
  before_action :set_account, only: [:show, :edit, :update, :destroy]
  before_action :set_roles, only: [:new, :create, :edit, :update]

  def index
    @accounts = Account.all

    respond_with @accounts
  end

  def show
    respond_with @account
  end

  def new
    @account = Account.new
    respond_with @account
  end

  def edit
    respond_with @account
  end

  def create
    @account = Account.create(account_params)
    respond_with @account, location: [:admin, @account]
  end

  def update
    @account.update(account_params)
    respond_with @account, location: [:admin, @account]
  end

  def destroy
    @account.destroy
    respond_with @account, location: admin_accounts_url
  end

  private
    def set_account
      @account = find_account
    end

    def find_account
      Account.find(params[:id])
    end

    def set_roles
      @roles = Role.all
    end

    def account_params
      params.
        require(:account).
        permit(:email, :password, role_ids: [])
    end
end
