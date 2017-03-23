class SessionsController < ApplicationController
  def allowed
    {
      new: :guest,
      destroy: :member,
    }
  end

  def new
    redirect_to root_path
  end

  def destroy
    logout
    redirect_to params.fetch("redirect_to", root_path)
  end

  private

  def session_params
    params.require(:session).permit(%i[email password])
  end
end
