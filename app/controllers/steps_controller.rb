# frozen_string_literal: true

class StepsController < ApplicationController
  layout 'step'

  def allowed
    {
      index: :member,
      show: :member,
      update: :member
    }
  end

  def index; end
end
