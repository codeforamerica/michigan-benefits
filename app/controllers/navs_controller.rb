class NavsController < ApplicationController
  layout "step"

  def allowed
    {
      show: :member
    }
  end

  def show
  end
end
