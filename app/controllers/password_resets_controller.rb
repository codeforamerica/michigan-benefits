class PasswordResetsController < ApplicationController
  skip_before_filter :require_login
  layout 'layouts/logged_out'

  def new
  end

  def create
    @account = Account.find_by(email: params[:email])

    @account.deliver_reset_password_instructions! if @account

    # Tell the user instructions have been sent whether or not email was found.
    # So we do not leak information to attackers about which emails exist.
    redirect_to root_path, notice: 'Instructions have been sent to your email.'
  end

  def edit
    @token = params[:id]
    @account = Account.load_from_reset_password_token(@token)

    not_authenticated if @account.blank?
  end

  def update
    @token = params[:id]

    lifecycle = AccountLifecycle.from_reset_token(@token)

    unless lifecycle.found?
      not_authenticated
      return
    end

    if lifecycle.reset_password?(params[:account][:password])
      login_without_credentials(lifecycle.account)
      redirect_to my_account_url, notice: 'Password successfully set.'
    else
      @account = lifecycle.account
      render :edit
    end
  end
end
