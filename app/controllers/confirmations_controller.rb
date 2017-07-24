# frozen_string_literal: true

class ConfirmationsController < ApplicationController
  layout "step"

  def allowed
    {
      show: :guest,
    }
  end

  def show; end
end
