class SessionsController < ApplicationController
  skip_before_filter :require_login

  def new
  end

  def create
    if @account = login(params[:email], params[:password])
      redirect_to my_account_path
    else
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_path
  end
end
