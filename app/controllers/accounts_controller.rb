class AccountsController < ApplicationController
  skip_before_filter :require_login, only: [:new, :create]

  def new
    @account = Account.new
    render layout: 'layouts/logged_out'
  end

  def create
    @account = AccountLifecycle.create(account_params).account
    if @account.persisted?
      auto_login(@account)
      redirect_to my_account_path
    else
      render :new, layout: 'layouts/logged_out'
    end
  end

  def edit
    @account = Account.find(params[:id])
  end

  def update
    @account = Account.find(params[:id])

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
