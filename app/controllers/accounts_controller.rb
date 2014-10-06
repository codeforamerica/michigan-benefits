class AccountsController < ApplicationController
  skip_before_filter :require_login
  layout 'layouts/raw'

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    if @account.save
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
