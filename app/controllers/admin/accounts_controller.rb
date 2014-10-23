class Admin::AccountsController < Admin::AdminBaseController
  before_action :set_account, only: [:show, :edit, :update, :destroy]

  # GET /admin/accounts
  def index
    @accounts = Account.all
  end

  # GET /admin/accounts/1
  def show
  end

  # GET /admin/accounts/new
  def new
    @account = Account.new
    @roles = Role.all
  end

  # GET /admin/accounts/1/edit
  def edit
    @roles = Role.all
  end

  # POST /admin/accounts
  def create
    @roles = Role.all
    @account = Account.new(account_params)
    roles = Role.find(params[:account][:roles] || [])

    if @account.save && @account.update(roles: roles)
      redirect_to [:admin, @account], notice: 'Account was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /admin/accounts/1
  def update
    @roles = Role.all
    roles = Role.find(params[:account][:roles] || [])

    if @account.update(account_params) && @account.update(roles: roles)
      redirect_to [:admin, @account], notice: 'Account was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/accounts/1
  def destroy
    @account.destroy
    redirect_to admin_accounts_url, notice: 'Account was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:email, :password)
    end
end
