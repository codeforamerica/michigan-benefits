# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :check_signups_enabled

  def allowed
    {
      new: :guest,
      create: :guest
    }
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(name: SecureRandom.uuid, password: SecureRandom.uuid, email: "#{SecureRandom.uuid}-auto@example.com")
    @user.save && auto_login(@user)
    respond_with @user, location: step_path(StepNavigation.first)
  end

  private

  def check_signups_enabled
    if ENV['SIGNUPS_DISABLED'] == 'true'
      flash[:alert] = 'Sorry, sign-ups are temporarily disabled'
      redirect_to root_path
    end
  end

  def user_params
    params.require(:user).permit %i[name email password]
  end
end
