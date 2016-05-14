class SessionsController < ApplicationController
  def allowed
    {
      new: :guest,
      create: :guest,
      destroy: :user,
    }
  end

  def new
  end

  def create
    if @user = login(session_params[:email], session_params[:password])
      redirect_back_or_to root_path
    else
      flash.now.alert = "Email or password is invalid"
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_path
  end

  private

  def session_params
    params.require(:session).permit(%i[email password])
  end
end
