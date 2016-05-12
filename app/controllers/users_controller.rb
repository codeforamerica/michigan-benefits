class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.save and auto_login(@user)
    respond_with @user, location: root_path
  end

  private

  def user_params
    params.require(:user).permit %i[name email password]
  end
end
