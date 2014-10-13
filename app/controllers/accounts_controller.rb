class AccountsController < ApplicationController
  skip_before_filter :require_login
  layout 'layouts/raw'

  def new
    @account = Account.new
  end

  def create
    @account = AccountCreator.create(account_params)
    if @account.persisted?
      auto_login(@account)
      redirect_to my_account_path
    else
      render :new
    end
  end

  private

    def account_params
      params.require(:account).permit(:email, :password)
    end
end
