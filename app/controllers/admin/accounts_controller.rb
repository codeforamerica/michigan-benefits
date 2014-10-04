class Admin::AccountsController < Admin::AdminBaseController
  before_action :set_account, only: [:show, :edit, :update, :destroy]

  # GET /admin/accounts
  # GET /admin/accounts.json
  def index
    @accounts = Account.all
  end

  # GET /admin/accounts/1
  # GET /admin/accounts/1.json
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
  # POST /admin/accounts.json
  def create
    @account = Account.new(account_params)
    roles = Role.find(params[:account][:roles] || [])

    respond_to do |format|
      if @account.save && @account.update(roles: roles)
        format.html { redirect_to [:admin, @account], notice: 'Account was successfully created.' }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/accounts/1
  # PATCH/PUT /admin/accounts/1.json
  def update
    roles = Role.find(params[:account][:roles] || [])

    respond_to do |format|
      if @account.update(account_params) && @account.update(roles: roles)
        format.html { redirect_to [:admin, @account], notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/accounts/1
  # DELETE /admin/accounts/1.json
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to admin_accounts_url, notice: 'Account was successfully destroyed.' }
      format.json { head :no_content }
    end
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
