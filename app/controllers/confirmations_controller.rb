class ConfirmationsController < ApplicationController

  def allowed
    {
      show: :guest
    }
  end

  def show
  end
end
