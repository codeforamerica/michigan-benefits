# frozen_string_literal: true

class LandingController < ApplicationController
  def allowed
    {
      show: :guest
    }
  end

  def show; end
end
