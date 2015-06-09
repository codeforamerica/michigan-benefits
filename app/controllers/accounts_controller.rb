class AccountsController < ApplicationController
  skip_before_filter :require_login, only: [:new, :create]

  def new
    @account = Account.new
    authorize @account
    render layout: 'layouts/logged_out'
  end

  def create
    @account = Account.new
    authorize @account
    AccountLifecycle.new(@account).create(account_params)
    authorize @account
    if @account.persisted?
      login_without_credentials(@account)
      redirect_to my_account_path
    else
      render :new, layout: 'layouts/logged_out'
    end
  end

  def edit
    @account = Account.find(params[:id])
    authorize @account
  end

  def update
    @account = Account.find(params[:id])
    authorize @account

    unless @account.authenticate(params.require(:account)[:old_password])
      flash.now.alert = "Old password invalid"
      render :edit
      return
    end

    unless AccountLifecycle.new(@account).reset_password?(params.require(:account)[:password])
      render :edit
      return
    end

    redirect_to my_account_path, notice: "Password changed!"
  end

  private

    def account_params
      params.require(:account).permit(:email, :password)
    end
end
