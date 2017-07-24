# frozen_string_literal: true

class StyleguidesController < ApplicationController
  layout :false

  def allowed
    {
      index: :guest,
    }
  end

  def index; end
end
