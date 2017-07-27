# frozen_string_literal: true

class UsersController < ApplicationController
  def allowed
    {
      new: :guest,
      create: :guest,
    }
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(
      name: SecureRandom.uuid,
      password: SecureRandom.uuid,
      email: "#{SecureRandom.uuid}-auto@example.com",
    )
    @user.save && auto_login(@user)
    respond_with @user, location: step_path(StepNavigation.first)
  end

  private

  def user_params
    params.require(:user).permit %i[name email password]
  end
end
